{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs;
  };
  
  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      packages."${system}".wine-lol = pkgs.wine-staging.overrideDerivation (oldAttrs: {
        patches = oldAttrs.patches ++ [
          ./0004-LoL-broken-client-update-fix.patch
          ./0005-LoL-client-slow-start-fix.patch
          ./0007-ntdll-stub-NtSetInformationThread-ThreadPriority.patch
          ./0008-ntdll-nopguard-call_vectored_handlers.patch
        ];
      });
      overlay = final: prev: {
        inherit (self.packages."${system}") wine-lol;
      };
    };
}
  
