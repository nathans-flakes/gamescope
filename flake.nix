{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    gamescope-src = {
      url = "https://github.com/Plagman/gamescope.git";
      flake = false;
      type = "git";
      submodules = true;
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, utils, gamescope-src }:
    utils.lib.eachDefaultSystem (system:
      with import nixpkgs { inherit system; };
      let
        unstable = import nixpkgs-unstable { inherit system; };
        gamescope = stdenv.mkDerivation rec {
          name = "gamescope";
          src = gamescope-src;
          buildInputs = with pkgs; [
            libdrm
            vulkan-headers
            vulkan-loader
            unstable.wayland
            unstable.wayland-protocols
            libxkbcommon
            libcap
            SDL2
            pipewire
            unstable.stb
            mesa
            udev
            pixman
            libinput
            seatd
            xwayland
            wlroots
            xorg.xinput
            xorg.libX11
            xorg.libXdamage
            xorg.libXcomposite
            xorg.libXrender
            xorg.libXext
            xorg.libXxf86vm
            xorg.libXtst
            xorg.libXres
            xorg.libxcb
            xorg.xcbutilwm
            xorg.xcbutilerrors
            xorg.libXi
          ];
          nativeBuildInputs = with pkgs; [
            pkg-config
            meson
            ninja
            cmake
            glslang
          ];
        };
      in
      {
        packages.gamescope = gamescope;
        defaultPackage = gamescope;
      });
}
