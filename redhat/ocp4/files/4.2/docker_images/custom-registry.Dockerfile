FROM registry.redhat.io/openshift4/ose-operator-registry:latest AS builder

COPY manifests manifests

# ENV DEBUGLOG true
# RUN pwd

RUN /bin/initializer -o ./bundles.db

# FROM scratch
FROM registry.redhat.io/openshift4/ose-operator-registry:latest

COPY --from=builder /registry/bundles.db /bundles.db
COPY --from=builder /usr/bin/registry-server /registry-server
COPY --from=builder /bin/grpc_health_probe /bin/grpc_health_probe

EXPOSE 50051

ENTRYPOINT ["/registry-server"]

CMD ["--database", "/bundles.db"]