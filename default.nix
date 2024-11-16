{ symlinkJoin, ags }:
symlinkJoin {
	name = "agsv1";
	paths = [ags];
	postBuild = ''
	  rm $out/bin/.ags-wrapped
	  mv $out/bin/ags $out/bin/agsv1
	'';
}
