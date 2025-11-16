# Example Mobile App

The goal for this app is to generate some newrelic data to be visualized in the top level project.

Before running the app make sure to update the server IP in main.dart to your current local IP and
start the test server. This refers to the kBaseUrl constant in main.dart.

Install wiremock `brew install wiremock-standalone`
To start the http test server do: `wiremock --port 8080`
