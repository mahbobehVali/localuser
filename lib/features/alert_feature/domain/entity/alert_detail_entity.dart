class AlertDetailEntity {
      int? id;
      String? alertId;
      String? userId;
      int? status;

      String? message;

      String? date;
      String? clock;
      String? createdAt;
      String? userName;


  AlertDetailEntity(this.id,this.alertId, this.userId,this.status,
      this.message,this.date,this.clock,this.createdAt,this.userName);
}
