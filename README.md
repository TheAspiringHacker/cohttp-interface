# Cohttp Lwt Async Common Interface

The Cohttp library offers a low-level common interface, but does not offer a
common interface for high-level features such as making GET requests. The Lwt
and Async APIs are extremely similar, yet have different types. This is a
library that unites the Lwt and Async implementations under one common
interface.
