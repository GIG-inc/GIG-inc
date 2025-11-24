# Project

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `project` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:project, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/project>.

Installing eventstoredb on ubuntu 24.04
# Install prerequisites
sudo apt-get update
sudo apt-get install -y curl apt-transport-https

# Download and add the EventStore GPG key
curl -fsSL https://packagecloud.io/EventStore/EventStore-OSS/gpgkey | sudo gpg --dearmor -o /etc/apt/keyrings/eventstore.gpg

# Add the repository (for Ubuntu 22.04/24.04)
echo "deb [signed-by=/etc/apt/keyrings/eventstore.gpg] https://packagecloud.io/EventStore/EventStore-OSS/ubuntu/ jammy main" | sudo tee /etc/apt/sources.list.d/eventstore.list

# Update and install
sudo apt-get update
sudo apt-get install -y eventstore-oss