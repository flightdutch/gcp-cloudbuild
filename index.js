// node.js app

exports.helloWorld = (req, res) => {
  const message="<font color='blue'>CloudFunction of ADV-IT!</font><br><b>App Version 1.0</b>";
  res.status(200).send(message);
};
