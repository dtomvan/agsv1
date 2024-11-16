{ symlinkJoin, ags }:
symlinkJoin {
	name = "agsv1";
	paths = [ags];
	postBuild = ''
	  mv $out/bin/ags $out/bin/agsv1
	'';
}
