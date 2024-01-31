# Official Dart image: https://hub.docker.com/_/dart
# Specify the Dart SDK base image version using dart:<version> (ex: dart:2.17)
FROM dart:stable AS build

WORKDIR /app

# Copy Dependencies


# Install Dependencies
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-cache policy sqlit3
RUN apt-get -y install sqlite3 libsqlite3-dev
RUN apt-get install -y ninja-build libgtk-3-dev
# Resolve app dependencies.
COPY pubspec.* ./
RUN dart pub get


# Copy app source code and AOT compile it.
COPY . .
# Ensure packages are still up-to-date if anything has changed
RUN dart pub get --offline
RUN dart compile exe bin/server.dart -o bin/server
RUN dart compile exe cmd_tools.dart -o bin/cmd_tools

# Get libsqlite3.so
FROM debian:bullseye-slim as sqlite

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y libsqlite3-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives && \
    cp /usr/lib/$(uname -m)-linux-gnu/libsqlite3.so /tmp/libsqlite3.so


# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/
COPY --from=build /app/bin/cmd_tools /app/bin/
COPY --from=sqlite /tmp/libsqlite3.so /usr/lib/libsqlite3.so
COPY dispatch_pi.db /.dart_tool/sqflite_common_ffi/databases/dispatch_pi.db


# Start server.
CMD ["/app/bin/server"]
