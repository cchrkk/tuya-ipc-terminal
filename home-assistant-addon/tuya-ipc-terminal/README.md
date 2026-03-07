# Tuya IPC Terminal Home Assistant Add-on

This add-on runs `tuya-ipc-terminal` as an RTSP bridge inside Home Assistant.

## Notes

- The add-on stores data in `/data/.tuya-data` (persistent add-on storage).
- You can run a bootstrap setup flow (`auth + cameras refresh`) at startup.

## Configuration

- `setup_mode`: Run setup flow before starting RTSP (`false` by default)
- `auth_method`: `qr` or `password`
- `region`: Tuya region name (for example `eu-central`)
- `email`: Tuya account email
- `password`: Tuya account password (required with `auth_method=password`)
- `country_code`: Optional phone country code for password flow (for example `49`)
- `rtsp_port`: RTSP server port (default: `8833`)

## Setup Mode Example

Use `setup_mode=true` with password auth for unattended bootstrap:

- `setup_mode`: `true`
- `auth_method`: `password`
- `region`: `eu-central`
- `email`: `user@example.com`
- `password`: `your-password`
- `country_code`: `49`
- `rtsp_port`: `8833`

## Stream URLs

- `rtsp://<ha-host>:<rtsp_port>/<camera-name>/hd`
- `rtsp://<ha-host>:<rtsp_port>/<camera-name>/sd`
