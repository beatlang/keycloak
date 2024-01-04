FROM quay.io/keycloak/keycloak:23.0 as builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Configure a database vendor
ENV KC_DB=postgres

# Define the default stack to use for cluster communication and node discovery
ENV KC_CACHE_STACK=kubernetes

WORKDIR /opt/keycloak
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:23.0
COPY --from=builder /opt/keycloak/ /opt/keycloak/

# change these values to point to a running postgres instance
ENV KC_DB=postgres
ENV KC_PROXY=edge
ENV KC_LOG_LEVEL=INFO

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]