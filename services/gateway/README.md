# Gateway

The gateway service is an ...

## Caching

The `gateway` service can use a configured store via `GATEWAY_STAT_CACHE_STORE`. Possible stores are:
  -   `memory`: Basic in-memory store and the default.
  -   `ocmem`: Advanced in-memory store allowing max size.
  -   `redis`: Stores data in a configured Redis cluster.
  -   `redis-sentinel`: Stores data in a configured Redis Sentinel cluster.
  -   `etcd`: Stores data in a configured etcd cluster.
  -   `nats-js`: Stores data using key-value-store feature of [nats jetstream](https://docs.nats.io/nats-concepts/jetstream/key-value-store)
  -   `noop`: Stores nothing. Useful for testing. Not recommended in production environments.

1.  Note that in-memory stores are by nature not reboot-persistent.
2.  Though usually not necessary, a database name and a database table can be configured for event stores if the event store supports this. Generally not applicable for stores of type `in-memory`. These settings are blank by default which means that the standard settings of the configured store apply.
3.  The gateway service can be scaled if not using `in-memory` stores and the stores are configured identically over all instances.
4.  When using `redis-sentinel`, the Redis master to use is configured via `GATEWAY_STAT_CACHE_STORE_NODES` in the form of `<sentinel-host>:<sentinel-port>/<redis-master>` like `10.10.0.200:26379/mymaster`.
