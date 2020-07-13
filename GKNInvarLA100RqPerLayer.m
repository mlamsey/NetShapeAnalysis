function GKNInvarLA100RqPerLayer(surface_comparison)
	% Assign hard-coded torch angle values for NGA sections
	degree_overhang(1:34) = 0;
	degree_overhang(35:36) = 10;
	degree_overhang(37:41) = 20;
	degree_overhang(42:46) = 30;
	degree_overhang(47:82) = 35;
	degree_overhang(83:103) = 30;
	degree_overhang(104:128) = 20;
	degree_overhang(129:139) = 10;
	degree_overhang(140:163) = 0;
	degree_overhang(164:175) = -10;
	degree_overhang(176:200) = -20;
	degree_overhang(201:223) = -30;
	degree_overhang(224:257) = -35;
	degree_overhang(258:262) = -30;
	degree_overhang(263:267) = -20;
	degree_overhang(268:269) = -10;
	degree_overhang(270:end) = 0;
end%func GKNInvarLA100RqPerLayer