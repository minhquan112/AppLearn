class ProcessItem {
  String title;
  String percent;

  ProcessItem({String title = "", String percent = "0%"})
      : this.title = title,
        this.percent = percent;

  ProcessItem.empty()
      : title = "",
        percent = "0%";
}
