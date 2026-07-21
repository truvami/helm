# Downlink credential deployment

Pre-create `downlinkCredentialKeys.secretName` with a `keyring.json` entry. The
file must be a JSON object mapping key IDs to base64-encoded 32-byte AES keys.
Set `locksmith.downlinkCredentials.keyring.activeKeyId` to the key used for new
writes and retain older keys until all rows have been rotated.
Set `locksmith.downlinkCredentials.thingpark.allowedHosts` to the exact external
LRC hosts that may be stored. An empty list rejects all ThingPark credentials.

The credential resolution RPC returns plaintext LNS credentials. Deploy it only
behind the trusted service mesh and enable `networkPolicy` with explicit Pulse
and API selectors. Enabling the policy with an empty `ingressFrom` list denies
all ingress.
