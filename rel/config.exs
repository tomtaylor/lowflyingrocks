# Import all plugins from `rel/plugins`
# They can then be used by adding `plugin MyPlugin` to
# either an environment, or release definition, where
# `MyPlugin` is the name of the plugin module.
Path.join(["rel", "plugins", "*.exs"])
|> Path.wildcard()
|> Enum.map(&Code.eval_file(&1))

use Mix.Releases.Config,
  # This sets the default release built by `mix release`
  default_release: :default,
  # This sets the default environment used by `mix release`
  default_environment: Mix.env()

# For a full list of config options for both releases
# and environments, visit https://hexdocs.pm/distillery/configuration.html

# You may define one or more environments in this file,
# an environment's settings will override those of a release
# when building in that environment, this combination of release
# and environment configuration is called a profile

environment :dev do
  set(dev_mode: true)
  set(include_erts: false)
  set(cookie: :k1YpFGekEWf6IV2nCeWLtQ8cX7IMoO5tUX233xtMM58W8pDua0vrbSByoJusyA2o)
  set(vm_args: "rel/vm.args")
end

environment :prod do
  set(include_erts: true)
  set(include_src: false)
  set(cookie: :"YBWAa7Vbdbqh5cr/TNC0h0NB+rhzmtC41ye3s9m6d2auyuxcCfZVQ2wCenNPg3ov")
  set(vm_args: "rel/vm.args")
end

# You may define one or more releases in this file.
# If you have not set a default release, or selected one
# when running `mix release`, the first release in the file
# will be used by default

release :lowflyingrocks do
  set(version: current_version(:lowflyingrocks))

  set(
    applications: [
      :runtime_tools
    ]
  )

  set(
    config_providers: [
      {Mix.Releases.Config.Providers.Elixir, ["${RELEASE_ROOT_DIR}/etc/config.exs"]}
    ]
  )

  set(
    overlays: [
      {:copy, "rel/config/config.exs", "etc/config.exs"}
    ]
  )
end
