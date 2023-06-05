FROM rust:buster AS builder

RUN \
  mkdir /root/ats && \
  mkdir /root/ats/src 

WORKDIR /root/ats

COPY Cargo.lock .
COPY Cargo.toml .

WORKDIR /root/ats/src

COPY src/main.rs .

WORKDIR /root/ats

RUN cargo build --release


FROM debian:bookworm-slim

WORKDIR /usr/bin

COPY --from=builder /root/ats/target/release/ats_image_server_rust .

RUN chmod -R +rwx /usr/bin/ats_image_server_rust

WORKDIR /

RUN \
  mkdir /root/ats && \
  mkdir /root/ats/landscape && \
  mkdir /root/ats/portrait

# WORKDIR /root/ats



WORKDIR /root/ats/landscape

COPY images/landscape .

WORKDIR /root/ats/portrait

COPY images/portrait .

WORKDIR /root/ats

# ENV PATH="/root/ats:$PATH" 

EXPOSE 8080

STOPSIGNAL SIGINT

# CMD ["tail", "-f", "/dev/null"]
CMD ["/usr/bin/ats_image_server_rust"]
