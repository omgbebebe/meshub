{ pkgs, lib, config, inputs, ... }:

let
  unstable = import inputs.nixpkgs-unstable { system = pkgs.stdenv.system; config.allowUnfree = true; };
  meshtastic_protobuf = pkgs.callPackage ./nix/meshtastic/protobuf.nix { pkgs = pkgs; lib = lib; };
in
{
  # https://devenv.sh/basics/
  env.GREET = "devenv";

  languages.rust = {
    enable = true;
    channel = "nixpkgs";
    components = [ "rustc" "cargo" "clippy" "rustfmt" "rust-analyzer" ];
  };
  # https://devenv.sh/packages/
  packages = with pkgs; [
    git
    nats-server
    natscli nsc nats-top
    unstable.surrealdb
    vector
    mqttui
    buf protobuf
    (python312.withPackages (ps: with ps; [paho-mqtt protobuf pycryptodome]))
    meshtastic_protobuf
  ];

  # https://devenv.sh/languages/
  # languages.rust.enable = true;

  # https://devenv.sh/processes/
  # processes.cargo-watch.exec = "cargo-watch";
  processes =
    let
      nats_count = 3;
      routes = map (x: let n = toString x; in "nats://127.0.0.1:622${n}")
          (lib.range 1 nats_count);
      nodes = lib.listToAttrs (
        map (x: 
          let
            n = toString x;
            selfRoute = "nats://127.0.0.1:622${n}";
            rs = lib.concatStringsSep "," (lib.lists.remove selfRoute routes);
            cmd = [
              "NATS_CLUSTER_LEAF_PORT=742${n} ${pkgs.nats-server}/bin/nats-server"
              "-c ./nats/nats.cluster0${n}.conf"
              "--routes ${rs}"
              "--port 522${n}"
              "--cluster_name NATS"
              "--cluster nats://0.0.0.0:622${n}"
              "-http_port 822${n}"
              "--jetstream"
              "-store_dir ./.runtime_data/nats0${n}"
              "-server_name nats0${n}"
            ];
          in
            { name = "nats-cl-srv0${toString(n)}";
              value = {
                exec = lib.concatStringsSep " " cmd;
              };
            })
          (lib.range 1 nats_count));
    in nodes // {
        #nats-top.exec = "sleep 5; nats-top -s 127.0.0.1 -m 8221";
        surrealdb.exec = "SURREAL_CAPS_ALLOW_EXPERIMENTAL=graphql ${unstable.surrealdb}/bin/surreal start --user admin --pass admin --bind 0.0.0.0:8088 rocksdb:./.runtime_data/surrealdb/sarmesh.db";
	nats-leaf.exec = "${pkgs.nats-server}/bin/nats-server -c ./nats/nats.local.leaf.conf";
        vector.exec = "cd vector; ${pkgs.vector}/bin/vector --config-toml ./vector.toml";
      };

  # https://devenv.sh/services/
  # services.postgres.enable = true;

  # https://devenv.sh/scripts/
  scripts.hello.exec = ''
    echo hello from $GREET
  '';

  enterShell = ''
    hello
    git --version
    ln -sf ${meshtastic_protobuf}/meshtastic.binpb ./vector/
  '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
