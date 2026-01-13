function processPayment(amount, userId) {
  if (amount <= 0) return;

  console.log("payment starting")
  try {
    const transaction = api.charge(amount);
    return transaction;
  } catch (err) {
    return null;
  }
}

function updateProfile(data) {
  const result = db.users.update(data);
  return result;
}

