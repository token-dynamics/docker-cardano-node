with import <nixpkgs> {};
let
  nixpkgs_tf = fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "178ec8974ff70ef0acffa4cc8f47f3234898ff3d";
    sha256 = "1l5jzf2bcs6knqafmz1lbaxm3m03r34nn4gqzskbmlyjh1fxbcn5";
  };
  pinnedPkgs = import nixpkgs_tf {};
in mkShell {
  name = "terraform";
  buildInputs = [
    pinnedPkgs.terraform_0_14
    awscli aws-iam-authenticator jq
    tree
  ];
}
