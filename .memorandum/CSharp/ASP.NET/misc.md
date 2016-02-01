# lock validation

以下の様に面倒なことをやる必要があると思ったが、勘違いだった。
```csharp
public ActionResult CreateReservation([Bind(Include = "STime,Name")] Reservation res) {
  using (var db = new MvcBasicContext()) {
    db.ExecuteSqlCommand("LOCK TABLES Reservations WRITE;");

    var overlapping = from r in db.Reservations where IsOverlapping(r, res) select r;
    if (overlappint.Count() != 0) {
      ModelState.AddModelError("STime", "予約が重複しています");
    } else {
      db.Reservations.Add(res);
      db.SaveChanges();
    }

    db.ExecuteSqlCommand("UNLOCK TABLES;");
  }

  if (ModelState.IsValid) {
    return RedirectToAction("List");
  } else {
    return View(res);
  }
}
```

以下の様でよい。
```csharp
using System.Data;
private MvcBasicContext db = new MvcBasicContext();

public ActionResult CreateReservation([Bind(Include = "STime,Name")] Reservation res) {
  using (var tx = db.Database.BeginTransaction(IsolationLevel.Serializable)) {}
    var overlapping = from r in db.Reservations where IsOverlapping(r, res) select r;

    if (overlappint.Count() != 0) {
      ModelState.AddModelError("STime", "予約が重複しています");
      tx.Rollback();
      return View(res);
    } else {
      db.Reservations.Add(res);
      db.SaveChanges();
      tx.Commit();
      return RedirectToAction("List");
    }
  }
}
```
胆であるBeginTransaction()メソッドについては<https://msdn.microsoft.com/ja-jp/library/dn220039(v=vs.113).aspx>
