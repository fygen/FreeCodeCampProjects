function checkCashRegister(pr, cs, cid) {
  let conv = [10, 50, 100, 250, 1000, 5000, 10000, 20000, 100000];
  let price = pr * 1000;
  let cash = cs * 1000;
  let change = cash - price;
  let cidTotal = 0;
  let ret = [];

  for (let i = 0; i < cid.length; i++) {
    cid[i][1] = cid[i][1] * 1000;
    cidTotal += cid[i][1];
    if (change > conv[cid.length - i]) {
      let z = Math.round(change / conv[cid.length - i]);
      if (z * conv[cid.length - i] > cid[cid.length - i][1]) {
        z = cid[cid.length - i][1] / conv[cid.length - i];
        change -= z * conv[cid.length - i];
        cid[cid.length - i][1] -= z * conv[cid.length - i];
        ret.push([cid[cid.length - i][0], z * conv[cid.length - i] / 1000])
      } else {
        change -= z * conv[cid.length - i];
        cid[cid.length - i][1] -= z * conv[cid.length - i];
        ret.push([cid[cid.length - i][0], z * conv[cid.length - i] / 1000])
      }
      console.log(conv[cid.length - i], z, cid[cid.length - i]);
    }
  }



  console.log("cid:", cid, "change:", change, "cdTot:", cidTotal, "ret", ret);
}

checkCashRegister(12, 20, [["PENNY", 1.01], ["NICKEL", 2.05], ["DIME", 3.1], ["QUARTER", 4.25], ["ONE", 90], ["FIVE", 55], ["TEN", 20], ["TWENTY", 60], ["ONE HUNDRED", 100]]);