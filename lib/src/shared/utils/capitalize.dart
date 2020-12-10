
String capitalize(String s) {
  if(s.isNotEmpty){
   return s[0].toUpperCase() + s.substring(1).toLowerCase();
  }else
    return s;
}
String capitaLizeFullName(String s){
  if(s!=null){
    List l = s.split(" ");
    var res = "";
    for(var item in l){
      res = res+capitalize(item)+" ";
    }
    return res;
  }

  return s;


}