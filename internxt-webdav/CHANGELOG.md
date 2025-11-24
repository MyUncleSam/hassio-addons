# Changelog

## 1.1.0 - 2025-11-24

- adjust backup to not include the image

## 1.0.8 - 2025-11-24

- Updated base image to internxt/webdav:v1.6.0


## 1.0.7

- avoid backing up the image which bloats the backup

## 1.0.6

- fix healthchecks as calling webdav is not working

## 1.0.5

- made ports static

## 1.0.4

- switch to use WebDAV internal directly from the InternXT image
- document how to use the internal WebDAV and the exposed WebDAV

## 1.0.3

- seperate webdav and healthcheck logic

## 1.0.2

- fix nginx authentication
- better healthcheck to make addon start faster

## 1.0.1

- introduce nginx as webdav proxy

## 1.0.0

- Initial release
