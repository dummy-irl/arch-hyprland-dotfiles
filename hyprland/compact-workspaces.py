#!/usr/bin/env python3

import json
import os
import re
import socket
import subprocess
import sys
import time


def hyprctl_json(command):
    result = subprocess.run(
        ["hyprctl", "-j", command],
        check=True,
        capture_output=True,
        text=True,
        timeout=5,
    )
    return json.loads(result.stdout)


def hyprctl_batch(commands):
    if not commands:
        return
    subprocess.run(
        ["hyprctl", "--batch", ";".join(commands)],
        check=True,
        capture_output=True,
        text=True,
        timeout=10,
    )


def compact_after_removal(removed_id):
    if removed_id <= 0:
        return

    workspaces = hyprctl_json("workspaces")
    higher_ids = sorted(
        {
            int(workspace["id"])
            for workspace in workspaces
            if str(workspace.get("name", "")).isdecimal()
            and int(workspace["id"]) > removed_id
        },
        reverse=True,
    )
    if not higher_ids:
        return

    active_workspace = hyprctl_json("activeworkspace")
    active_id = int(active_workspace["id"])

    clients = hyprctl_json("clients")
    addresses_by_workspace = {}
    for client in clients:
        workspace_id = int(client.get("workspace", {}).get("id", 0))
        address = client.get("address")
        if workspace_id in higher_ids and address:
            addresses_by_workspace.setdefault(workspace_id, []).append(address)

    commands = []
    for old_id in higher_ids:
        new_id = old_id - 1
        for address in addresses_by_workspace.get(old_id, []):
            commands.append(
                f"dispatch movetoworkspacesilent {new_id},address:{address}"
            )
    hyprctl_batch(commands)

    if active_id > removed_id:
        hyprctl_batch([f"dispatch workspace {active_id - 1}"])


def main():
    runtime_dir = os.environ.get("XDG_RUNTIME_DIR")
    instance = os.environ.get("HYPRLAND_INSTANCE_SIGNATURE")
    if not runtime_dir or not instance:
        print("Hyprland runtime environment is missing", file=sys.stderr)
        return 1

    event_socket = os.path.join(
        runtime_dir, "hypr", instance, ".socket2.sock"
    )

    while True:
        try:
            with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as connection:
                connection.connect(event_socket)
                stream = connection.makefile("r", encoding="utf-8")
                for line in stream:
                    event, separator, data = line.rstrip("\n").partition(">>")
                    if not separator or event != "destroyworkspacev2":
                        continue
                    match = re.match(r"(-?\d+),", data)
                    if match:
                        try:
                            compact_after_removal(int(match.group(1)))
                        except (json.JSONDecodeError, KeyError, OSError, ValueError,
                                subprocess.SubprocessError) as error:
                            print(f"Workspace compaction failed: {error}", file=sys.stderr)
        except OSError as error:
            print(f"Workspace event socket unavailable: {error}", file=sys.stderr)
            time.sleep(2)


if __name__ == "__main__":
    raise SystemExit(main())
