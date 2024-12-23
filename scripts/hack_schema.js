module.exports = hackSchema;

function hackRestartRequestArguments(schema) {
  const args = schema.definitions.RestartArguments;
  delete schema.definitions.RestartArguments;
  args.properties.arguments = {
    type: 'object',
    properties: schema.definitions.LaunchRequestArguments.properties
  };
  schema.definitions.RestartRequestArguments = args;
}

function hackSchema(schema) {
  schema.definitions.Variable.properties.__vscodeVariableMenuContext = { type: 'string' };
  hackRestartRequestArguments(schema);
  return schema;
}
