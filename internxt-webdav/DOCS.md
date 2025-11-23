# Internxt WebDAV Add-on

This add-on allows you to mount your Internxt Drive as a WebDAV server, making it accessible to other applications and devices on your network.

## Configuration

### Required Options

- **email**: Your Internxt account email address
- **password**: Your Internxt account password

### Optional Options

- **two_factor_code**: Current 2FA one-time code (if 2FA is enabled)
- **otp_token**: OTP secret for automatic 2FA code generation
- **webdav_port**: WebDAV server port (default: 3005)
- **webdav_protocol**: Protocol to use - `http` or `https` (default: https)

## Usage

1. Install the add-on
2. Configure your Internxt credentials
3. Start the add-on
4. Connect to the WebDAV server at `https://your-ha-ip:3005`

## Two-Factor Authentication

If you have 2FA enabled on your Internxt account, you have two options:

1. **One-time code**: Enter the current code in `two_factor_code` (requires manual update)
2. **OTP token**: Enter your OTP secret in `otp_token` for automatic code generation

## Support

For issues related to:
- **This add-on**: Report on the add-on repository
- **Internxt WebDAV**: Visit [Internxt CLI GitHub](https://github.com/internxt/cli)
