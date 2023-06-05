from smartredis import Client
from smartsim import Experiment

import numpy as np

exp = Experiment("Inference-Test", launcher="local")

db = exp.create_database(port=6899, interface="lo")
exp.start(db)

print(db.get_address())

model_path = '/work/tc045/tc045/shared/model/zero-model-256.pb'
inputs = ['x']
outputs = ['Identity']
model_name = "zero_model_256"

client = Client(address=db.get_address()[0], cluster=False)

client.set_model_from_file(
    model_name, model_path, "TF", device="CPU", inputs=inputs, outputs=outputs
)

# put random random input tensor into the database
input_data = np.random.rand(1, 260, 256, 1).astype(np.float32)
client.put_tensor("input", input_data)

# run the Fully Connected Network model on the tensor we just put
# in and store the result of the inference at the "output" key
client.run_model(model_name, "input", "output")

# get the result of the inference
pred = client.get_tensor("output")
print(pred)
