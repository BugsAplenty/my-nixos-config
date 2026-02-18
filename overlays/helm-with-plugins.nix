# overlays/helm-with-plugins.nix
self: super:

let
  # Helm wrapped with the plugins we want
  helmWrapped =
    super.wrapHelm super.kubernetes-helm {
      plugins = with super.kubernetes-helmPlugins; [
        helm-diff
        helm-secrets
        helm-s3
        helm-git
      ];
    };
in
{
  # expose both binaries
  helmWrapped            = helmWrapped;
  helmfileWrapped = super.helmfile-wrapped.override {
    inherit (helmWrapped) pluginsDir;   # ← critical!
  };
}
