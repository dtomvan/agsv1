self: {
  config,
  pkgs,
  lib,
  ...
}: let
cfg = config.programs.agsv1; 
in {
	options.programs.agsv1 = with lib; {
		enable = mkEnableOption "ags v1";
		package = mkPackageOption pkgs "agsv1" {};
		configPath = mkOption {
			description = "path to ags v1 config, to be placed in nix store.";
			type = with types; nullOr path;
			example = literalExpression "./ags";
		};
	};
	config = lib.mkIf cfg.enable (let
	  doConfig = cfg.configPath != null;
	  finalPackage = if doConfig then cfg.package.overrideAttrs {
		  nativeBuildInputs = [ pkgs.makeWrapper ];
		  installPhase = ''
		  wrapProgram $out/bin/agsv1 --add-flags -c ${lib.escapeShellArg cfg.configPath}
		  '';
	  } else cfg.package;
	in {
		home.packages = [ finalPackage ];
		xdg.configFile.agsv1 = lib.mkIf doConfig {
			recursive = true;
			source = cfg.configPath;
		};
	});
}
