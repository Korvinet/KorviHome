class HomeSeerDevice {
  int ref;
  String name;
  String location;
  String location2;
  double value;
  String status;
  bool isFav = false;

  toggleFavorite(){
    this.isFav = !this.isFav;
  }

  HomeSeerDevice(this.ref, this.name, this.location, this.location2, this.value, this.status);
}