{ lib
, pkgs
}:
with pkgs;

stdenv.mkDerivation rec {
  pname = "meshtastic-protobuf";
  version = "2.7.12";

  src = fetchFromGitHub {
    owner   = "meshtastic";
    repo    = "protobufs";
    rev     = "v${version}";
    sha256  = "sha256-25V+NkXauQYPGM866mEeWRjTjN5SMj7iVBFaPHAKZtM=";
  };

  nativeBuildInputs = [ buf ];

  buildPhase = ''
    export HOME=$(pwd)
    rm -f buf.yaml
    pwd
    buf build --output meshtastic.binpb
  '';

  installPhase = ''
    mkdir -p $out
    cp meshtastic.binpb $out/
  '';
}
