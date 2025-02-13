# Web

The web service embeds and serves the static files for the [Infinite Scale Web Client](https://github.com/owncloud/web).  
Note that clients will respond with a connection error if the web service is not available.

The web service also provides a minimal API for branding functionality like changing the logo shown.

## Custom Compiled Web Assets

If you want to use your custom compiled web client assets instead of the embedded ones, then you can do that by setting the `WEB_ASSET_PATH` variable to point to your compiled files. See [ownCloud Web / Getting Started](https://owncloud.dev/clients/web/getting-started/) and [ownCloud Web / Setup with oCIS](https://owncloud.dev/clients/web/backend-ocis/) for more details.

## Web UI Configuration

Note that single configuration settings of the embedded web UI can be defined via `WEB_OPTION_xxx` environment variables. If a json based configuration file is used via the `WEB_UI_CONFIG_FILE` environment variable, these configurations take precedence over single options set.

### Web UI Options

Beside theming, the behavior of the web UI can be configured via options. See the environment variables `WEB_OPTION_xxx` for more details.

### Web UI Config File

When defined via the `WEB_UI_CONFIG_FILE` environment variable, the configuration of the web UI can be made with a [json based](https://github.com/owncloud/web/tree/master/config) file.
