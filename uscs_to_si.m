% Script that converts USCS units to SI units

MPH_TO_KMH = 1.60934;
LBS_TO_N = 4.448221653;
FT_TO_M = 0.3048;
PSI_TO_KPA = 6.89476;

LBFT_TO_NM = LBS_TO_N * FT_TO_M;

round_id = '1051';
run_num = '41';
old_file_name = ['TTC Tire Data/' round_id 'run' run_num '.mat'];
old = load(old_file_name);
AMBTMP = F_to_C(old.AMBTMP);
ET = old.ET;
FX = old.FX * LBS_TO_N;
FY = old.FY * LBS_TO_N;
FZ = old.FZ * LBS_TO_N;
IA = old.IA;
MX = old.MX * LBFT_TO_NM;
MZ = old.MZ * LBFT_TO_NM;
N = old.N;
NFY = old.NFY;
P = old.P * PSI_TO_KPA;
RE = old.RE * FT_TO_M;
RL = old.RL * FT_TO_M;
RST = F_to_C(old.RST);
SA = old.SA;
SR = old.SR;
TSTC = F_to_C(old.TSTC);
TSTI = F_to_C(old.TSTI);
TSTO = F_to_C(old.TSTO);
V = old.V * MPH_TO_KMH;
tireid = old.tireid;

save(['TTC Tire Data/B1052run' run_num '.mat'], 'AMBTMP', 'ET', 'FX', 'FY', 'FZ', 'IA', 'MX', 'N', 'NFY', 'P', 'RE', 'RL', 'RST', 'SA', 'SR', 'TSTC', 'TSTI', 'TSTO', 'V', 'tireid');
delete(old_file_name);

function temp_C = F_to_C(temp_F)
    temp_C = (temp_F - 32) * 5/9;
end