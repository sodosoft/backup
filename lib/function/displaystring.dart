import 'package:intl/intl.dart';

class DisplayString{
  String resultDisplay;

  DisplayString(this.resultDisplay);

  static displayArea(resultDisplay)
  {
    String result = '';
    List<String> listArea = [];
    listArea = resultDisplay.toString().split(' ');

    if(listArea.length > 1) {
      result = listArea[0] + ' ' + listArea[1];
    }
    else
    {
      result = resultDisplay;
    }

    return result;
  }

  static displayDate(resultDisplay)
  {
    String result = '';
    String resultDate = '';
    String resultTime = '';

    List<String> listDate = [];
    listDate = resultDisplay.toString().split(' ');

    resultDate = listDate[0].substring(0,5).replaceAll('-', '월')  +
                 listDate[0].substring(5,3).replaceAll('-', '일');
    result = resultDate;

    return result;
  }

  static displayCost(resultDisplay)
  {
    String result = '';
    var f = NumberFormat('###,###,###,###');
    result = f.format(int.parse(resultDisplay)).toString();

    return result;
  }

}