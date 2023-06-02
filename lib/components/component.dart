import 'package:flutter/material.dart';

Widget DefaultButton({
  double height = 35,
  double containerheight = 30,
  double fontsize = 20,
  double width = double.infinity,
  Color color = Colors.blue,
  Color textcolor = Colors.white,
  Color bordercolor = Colors.transparent,
  @required var function,
  double radius = 10,
  @required var text,
  bool uppercase = true,
}) =>
    Container(
      height: containerheight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: bordercolor),
        color: color,
      ),
      width: width,
      child: MaterialButton(
        onPressed: function,
        height: height,
        child: Text(uppercase ? text.toUpperCase() : text,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: fontsize,
                color: textcolor)),
      ),
    );

Widget DefaultFormField(
        {@required TextEditingController? controller,
        TextInputType texttype = TextInputType.emailAddress,
        var prefixicon,
        var sufixicon,
        @required String? label,
        var validate,
        bool password = false,
        int maxlines = 1,
        double? container_height,
        double? container_width,
        var suffixbutton}) =>
    TextFormField(
        controller: controller,
        keyboardType: texttype,
        obscureText: password,
        maxLines: maxlines,
        decoration: InputDecoration(
            // hintText: 'Email Address',
            prefixIcon: Icon(prefixicon == null ? null : prefixicon),
            suffixIcon: IconButton(
                onPressed: suffixbutton,
                icon: Icon(sufixicon == null ? null : sufixicon)),
            labelText: label,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        validator: validate);

Widget taskslist({required Map items}) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(
              '${items['time']}',
              style: TextStyle(fontSize: 15),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${items['title']}',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                '${items['date']}',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              )
            ],
          ),
        ],
      ),
    );

void navigate_to({@required context, @required widget}) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

void navigateandfinish({@required context, @required widget}) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (contex) => widget),
      (route) => false).then((value) {});
}

Widget formFieldWithContainer({
  Color? containerColor,
  double radius = 20,
  IconData prefxicon = Icons.lock,
  required String? text,
  required TextEditingController? controller,
  var ontap,
  var onsubmit,
}) =>
    Container(
      decoration: BoxDecoration(
          color: containerColor ?? Colors.grey.withOpacity(.2),
          borderRadius: BorderRadius.circular(radius)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: TextFormField(
          onTap: ontap,
          onFieldSubmitted: onsubmit,
          controller: controller,
          textAlign: TextAlign.right,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          decoration: InputDecoration(
              prefixIcon: Icon(prefxicon),
              border: InputBorder.none,
              hintText: text),
        ),
      ),
    );

void showSnackBar(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
