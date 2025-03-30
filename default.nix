{ pkgs ? import <nixpkgs> { } }:
{
  fokquote = pkgs.callPackage ./pkgs/fokquote {};
}
