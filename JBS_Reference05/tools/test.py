from pathlib import Path
import argparse,subprocess,json
ROOT=Path(__file__).resolve().parents[1]
parser=argparse.ArgumentParser();parser.add_argument('--luau',required=True);parser.add_argument('--compiler',required=True);args=parser.parse_args()
subprocess.run(['python3',str(ROOT/'tools/build.py')],check=True)
files=sorted((ROOT/'src').glob('*.lua'))+[ROOT/'JBS_Reference05.client.lua']+sorted((ROOT/'tests').glob('Native*.client.lua'))
for path in files:subprocess.run([args.compiler,str(path)],stdout=subprocess.DEVNULL,check=True)
module=(ROOT/'tests/modules.bundle.luau').read_text()
test=(ROOT/'tests/mock-engine.luau').read_text()+'\nlocal Modules=(function()\n'+module+'\nend)()\n'+(ROOT/'tests/stress.luau').read_text()
scratch=Path.cwd()/'work/JBS_Reference05';scratch.mkdir(parents=True,exist_ok=True)
path=scratch/'run.generated.luau';path.write_text(test)
result=subprocess.run([args.luau,str(path)],text=True,capture_output=True)
log='Offline Luau test double, NOT a Roblox native test.\n'+result.stdout+result.stderr
(ROOT/'evidence/offline-tests.txt').write_text(log)
print(log)
if result.returncode:raise SystemExit(result.returncode)
avatar_test=(ROOT/'tests/mock-engine.luau').read_text()+'\n'+(ROOT/'tests/avatar-engine.luau').read_text()+'\nlocal Modules=(function()\n'+module+'\nend)()\n'+(ROOT/'tests/avatar-stress.luau').read_text()
avatar_path=scratch/'avatar.generated.luau';avatar_path.write_text(avatar_test)
avatar_result=subprocess.run([args.luau,str(avatar_path)],text=True,capture_output=True)
avatar_log='Offline avatar engine double, NOT a Roblox native test.\n'+avatar_result.stdout+avatar_result.stderr
(ROOT/'evidence/offline-avatar-tests.txt').write_text(avatar_log);print(avatar_log)
if avatar_result.returncode:raise SystemExit(avatar_result.returncode)
dual_test=(ROOT/'tests/mock-engine.luau').read_text()+'\n'+(ROOT/'tests/avatar-engine.luau').read_text()+'\nlocal Modules=(function()\n'+module+'\nend)()\n'+(ROOT/'tests/dual-avatar-stress.luau').read_text()
dual_path=scratch/'dual-avatar.generated.luau';dual_path.write_text(dual_test)
dual_result=subprocess.run([args.luau,str(dual_path)],text=True,capture_output=True)
dual_log='Stage 2 offline engine double; NOT Roblox native verification.\n'+dual_result.stdout+dual_result.stderr
(ROOT/'evidence/offline-dual-avatar-tests.txt').write_text(dual_log);print(dual_log)
if dual_result.returncode:raise SystemExit(dual_result.returncode)
report={'compiled_files':len(files),'offline_luau_status':'passed','native_render':'not_verified','native_performance':'not_measured','resource_uploads':'pending','business_integration':'not_present_in_current_project'}
report.update(avatar_offline_status='passed',dual_avatar_offline_status='passed',avatar_native_status='not_verified',avatar_real_accounts_tested=0,avatar_test_looks='offline fixtures only; Studio fixtures pending',avatar_clean_background='front and back local PNGs complete; upload, permission and native verification pending',avatar_scope='shared appearance; independent front and back displays')
(ROOT/'evidence/verification.json').write_text(json.dumps(report,indent=2)+'\n')
