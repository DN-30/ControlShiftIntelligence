from dotenv import load_dotenv
from mira_sdk import MiraClient, Flow, File, Reader, ComposioConfig
import os

script_dir = os.path.dirname(os.path.abspath(__file__))
project_dir = os.path.dirname(script_dir)
gameai_path = os.path.join(script_dir, "gameai.yaml")
fight_data_path = os.path.join(project_dir, "src", "json", "fight_data.json")
boss_code_path = os.path.join(project_dir, "src", "BossData.gd")

load_dotenv()
client = MiraClient(config={"API_KEY": os.getenv("MIRA_API_KEY")})
flow = Flow(source=gameai_path)
input_dict = {"fightdata": File(file_path=fight_data_path),
              "bosscode": File(file_path=boss_code_path)}
response = client.flow.test(flow, input_dict)
with open(boss_code_path,"w") as file:
    file.write(response["result"])

