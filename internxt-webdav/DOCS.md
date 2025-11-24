# Internxt WebDAV Add-on

Mount your Internxt Drive as a WebDAV server for easy file access from Home Assistant and other devices on your network.

## Configuration

### Required

| Option | Description |
|--------|-------------|
| Email | Your Internxt account email address |
| Password | Your Internxt account password |

### Optional

| Option | Description | Default |
|--------|-------------|---------|
| Two-Factor Code | Current 2FA one-time code (if enabled) | - |
| OTP Token | OTP secret for automatic 2FA code generation | - |
| WebDAV Username | Username for external access authentication | webdav |
| WebDAV Password | Password for external access authentication | - |

## Usage

1. Install the add-on
2. Configure your Internxt credentials
3. Start the add-on

### Internal Usage (Home Assistant Backups)

Use this method to store Home Assistant backups on your Internxt Drive.

**Setup:**

1. Go to the add-on info page and copy the hostname (e.g., `1234b6b8-ix-webdav`)
2. Add a new network storage location in Home Assistant with these settings:

| Setting | Value |
|---------|-------|
| URL | `http://1234b6b8-ix-webdav:3005` (replace with your hostname) |
| Username | Any value (e.g., `internxt-backup`) - displayed in the list only |
| Password | Any value - not validated by the internal server |
| Backup Path | Folder path on Internxt (e.g., `/backups/homeassistant`) |
| SSL | Unchecked (internal traffic uses HTTP) |

### External Access (Experimental)

Expose Internxt WebDAV to your home network with authentication protection.

**Setup:**

1. Go to the add-on configuration page
2. Set **WebDAV Username** and **WebDAV Password**
3. Enable the port mapping on port 3006 (disabled by default)
4. Connect using `http://homeassistant.local:3006`

**Note:** External access only supports HTTP connections. If you have choosen a differnt port to map than 3006 you need to specify this port.

## Two-Factor Authentication

If 2FA is enabled on your Internxt account:

| Method | Field | Notes |
|--------|-------|-------|
| One-time code | Two-Factor Code | Requires manual update each time - not recommended |
| OTP secret | OTP Token | Automatic code generation - recommended |

## Support

| Issue Type | Where to Report |
|------------|-----------------|
| Add-on issues | [Add-on Repository](https://github.com/ruepp-jenkins/hassio-addons) |
| Internxt WebDAV bugs | [Internxt CLI GitHub](https://github.com/internxt/cli) |
