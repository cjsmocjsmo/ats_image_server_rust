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

RUN \
  mkdir /root/ats && \
  mkdir /root/ats/landscape && \
  mkdir /root/ats/portrait

WORKDIR /root/ats

COPY --from=builder /root/ats/target/release/ats_image_server_rust .

RUN chmod -R +rwx /root/ats/ats_image_server_rust

WORKDIR /root/ats/landscape

COPY images/landscape /root/ats/landscape/

WORKDIR /root/ats/portrait

COPY images/portrait /root/ats/portrait/

WORKDIR /root/ats

ENV PATH="/root/ats:$PATH" 

EXPOSE 8080

STOPSIGNAL SIGINT

# CMD ["tail", "-f", "/dev/null"]
CMD ["ats_image_server_rust"]
