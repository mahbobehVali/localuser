

class WellWorkListEntity {
    final String? title;
    final String? type;
    List<dynamic>? xAxis;
        List<dynamic>? yAxis;
   // final  List<WellWorkListSeriesEntity>? series;
    dynamic totalOn;
    dynamic totalOff;

    WellWorkListEntity( this.title, this.type,this.xAxis,this.yAxis,this.totalOn,this.totalOff);
}
