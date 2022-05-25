import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder/country.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:form_builder_file_picker/form_builder_file_picker.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class FormBuilderDemo extends StatefulWidget {
  const FormBuilderDemo({
    Key? key,
  }) : super(key: key);

  @override
  State<FormBuilderDemo> createState() => _FormBuilderDemoState();
}

class _FormBuilderDemoState extends State<FormBuilderDemo> {
  bool autoValidate = true;
  bool readOnly = false;
  bool showSegmentedControl = true;
  final _formKey = GlobalKey<FormBuilderState>();

  bool _ageHasError = false;

  bool _genderHasError = false;

  var genderOptions = ['Male', 'Female', 'Gay'];

  void _onChanged(dynamic val) => debugPrint(val.toString());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Builder Demo'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FormBuilder(
                key: _formKey,
                onChanged: () {
                  _formKey.currentState!.save();
                  debugPrint(_formKey.currentState!.value.toString());
                },
                //autovalidateMode untuk menampilkan pesan error
                autovalidateMode: AutovalidateMode.disabled,
                skipDisabled: true,
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 15,
                    ),
                    FormBuilderTextField(
                      name: 'email',
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email(),
                      ]),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    FormBuilderTextField(
                      name: 'age',
                      autovalidateMode: AutovalidateMode.always,
                      decoration: InputDecoration(
                        labelText: 'Age',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        suffixIcon: _ageHasError
                            ? const Icon(
                                Icons.error,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                      ),
                      // valueTransformer: (text) => num.tryParse(text!),
                      onChanged: (val) {
                        setState(() {
                          _ageHasError = !(_formKey.currentState?.fields['age']?.validate() ?? false);
                        });
                      },
                      initialValue: '0',
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.max(70),
                      ]),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    FormBuilderDateRangePicker(
                      name: 'date_range',
                      firstDate: DateTime(1970),
                      lastDate: DateTime(2030),
                      format: DateFormat('yyyy-MM-dd'),
                      decoration: InputDecoration(
                        labelText: 'Date Range',
                        helperText: 'Helper Text',
                        hintText: 'Hint Text',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _formKey.currentState!.fields['date_range']?.didChange(null);
                          },
                        ),
                      ),
                    ),
                    FormBuilderDateTimePicker(
                      name: 'date',
                      initialEntryMode: DatePickerEntryMode.calendar,
                      initialDate: DateTime.now(),
                      onChanged: _onChanged,
                      inputType: InputType.both,
                      decoration: InputDecoration(
                        labelText: 'Appoint Time',
                        suffixIcon: IconButton(
                          onPressed: () {
                            _formKey.currentState!.fields['date']?.didChange(null);
                          },
                          icon: const Icon(Icons.close),
                        ),
                      ),
                      initialTime: const TimeOfDay(hour: 8, minute: 0),
                      locale: const Locale('id'),
                    ),
                    FormBuilderFilterChip(
                      name: 'filter_chip',
                      decoration: const InputDecoration(
                        labelText: 'Filter Chip',
                      ),
                      selectedColor: Colors.blue,
                      backgroundColor: Colors.red,
                      checkmarkColor: Colors.white,
                      options: const [
                        FormBuilderFieldOption(
                          value: '1',
                          child: Text(
                            'Option 1',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        FormBuilderFieldOption(
                          value: '2',
                          child: Text(
                            'Option 2',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        FormBuilderFieldOption(
                          value: '3',
                          child: Text(
                            'Option 3',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        FormBuilderFieldOption(
                          value: '4',
                          child: Text(
                            'Option 4',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        FormBuilderFieldOption(
                          value: '5',
                          child: Text(
                            'Option 5',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    FormBuilderSegmentedControl(
                      name: 'segmented',
                      validator: (val) {
                        if (val == null) {
                          return 'Please select one option';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Segmented Control',
                      ),
                      options: const [
                        FormBuilderFieldOption(
                          value: '1',
                          child: Text('Option 1'),
                        ),
                        FormBuilderFieldOption(
                          value: '2',
                          child: Text('Option 2'),
                        ),
                        FormBuilderFieldOption(
                          value: '3',
                          child: Text('Option 3'),
                        ),
                      ],
                      onChanged: _onChanged,
                    ),
                    FormBuilderChoiceChip(
                      name: 'choice_chip',
                      selectedColor: Colors.green,
                      backgroundColor: Colors.blue,
                      decoration: const InputDecoration(
                        labelText: 'What is your favorite ice flower?',
                      ),
                      options: const [
                        FormBuilderFieldOption(
                          value: 'chocolate',
                          child: Text(
                            'Chocolate 🍫',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        FormBuilderFieldOption(
                          value: 'strawberry',
                          child: Text(
                            'Strawberry 🍓',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        FormBuilderFieldOption(
                          value: 'vanilla',
                          child: Text(
                            'Vanilla 🍧',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        FormBuilderFieldOption(
                          value: 'Cookie Dough',
                          child: Text(
                            'Cookie Dough 🍪',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        FormBuilderFieldOption(
                          value: 'mango',
                          child: Text(
                            'Mango 🥭',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                      onChanged: _onChanged,
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    FormBuilderSlider(
                      name: 'slider',
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.min(6),
                      ]),
                      onChanged: _onChanged,
                      initialValue: 7.0,
                      min: 0.0,
                      max: 10.0,
                      divisions: 20,
                      activeColor: Colors.red,
                      inactiveColor: Colors.pink[100],
                      decoration: const InputDecoration(
                        labelText: 'Number of Things',
                      ),
                    ),
                    FormBuilderRangeSlider(
                      name: 'range_slider',
                      onChanged: _onChanged,
                      initialValue: const RangeValues(500, 1000),
                      min: 500.0,
                      max: 10000.0,
                      activeColor: Colors.red,
                      inactiveColor: Colors.pink[100],
                      decoration: const InputDecoration(
                        labelText: 'Price Range',
                      ),
                    ),
                    FormBuilderCheckbox(
                      name: 'accept_terms',
                      initialValue: false,
                      onChanged: _onChanged,
                      title: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'I agree to the ',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: 'Terms and Conditions',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                      validator: FormBuilderValidators.equal(
                        true,
                        errorText: 'You must accept terms and conditions',
                      ),
                    ),
                    FormBuilderDropdown<String>(
                      name: 'gender',
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        suffix: _genderHasError ? const Icon(Icons.error) : const Icon(Icons.check),
                      ),
                      allowClear: true,
                      hint: const Text('Select Gender'),
                      validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                      items: genderOptions
                          .map((gender) => DropdownMenuItem(
                                alignment: AlignmentDirectional.center,
                                value: gender,
                                child: Text(gender),
                              ))
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          _genderHasError = !(_formKey.currentState?.fields['gender']?.validate() ?? false);
                        });
                      },
                      valueTransformer: (val) => val?.toString(),
                    ),
                    FormBuilderRadioGroup<String>(
                      decoration: const InputDecoration(
                        labelText: 'My Choosen Language',
                      ),
                      initialValue: null,
                      name: 'best_language',
                      onChanged: _onChanged,
                      validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
                      options: ['Dart', 'Kotlin', 'Java', 'PHP', 'Swift', 'Objective-C']
                          .map((lang) => FormBuilderFieldOption(
                                value: lang,
                                child: Text(lang),
                              ))
                          .toList(growable: false),
                      controlAffinity: ControlAffinity.leading,
                    ),
                    FormBuilderFilePicker(
                      name: 'file_picker',
                      decoration: const InputDecoration(
                        labelText: 'Attachments',
                      ),
                      maxFiles: null,
                      allowMultiple: true,
                      previewImages: true,
                      selector: Row(
                        children: const [
                          Icon(Icons.file_upload),
                          Text('Upload'),
                        ],
                      ),
                      onFileLoading: (val) {
                        debugPrint('File Loading: $val');
                      },
                      onChanged: _onChanged,
                    ),
                    FormBuilderPhoneField(
                      name: 'phone_number',
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        hintText: '895-123-4567',
                      ),
                      priorityListByIsoCode: const ['US', 'CA', 'GB', 'AU', 'ID'],
                      defaultSelectedCountryIsoCode: 'ID',
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.numeric(),
                        FormBuilderValidators.required(),
                      ]),
                    ),
                    FormBuilderImagePicker(
                      name: 'image_picker',
                      decoration: const InputDecoration(
                        labelText: 'Image Picker',
                      ),
                      validator: FormBuilderValidators.required(),
                      maxImages: 2,
                      onImage: (val) {},
                      cameraIcon: const Icon(Icons.camera_alt),
                      cameraLabel: const Text('Take a picture'),
                      preferredCameraDevice: CameraDevice.rear,
                      fit: BoxFit.cover,
                    ),
                    FormBuilderSegmentedControl(
                      name: 'movie_rating',
                      decoration: const InputDecoration(
                        labelText: 'Movie Rating (Archer)',
                      ),
                      options: List.generate(10, (i) => i + 1)
                          .map((number) => FormBuilderFieldOption(
                                value: number,
                                child: Text(
                                  '$number',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ))
                          .toList(),
                      onChanged: _onChanged,
                    ),
                    FormBuilderSwitch(
                      name: 'accept_terms_switch',
                      title: const Text('I Accept the terms and condicitions'),
                      initialValue: true,
                      onChanged: _onChanged,
                    ),
                    FormBuilderSearchableDropdown(
                      name: 'searchable_dropdown',
                      items: country,
                      onChanged: _onChanged,
                      decoration: const InputDecoration(
                        labelText: 'Searchable Dropdown',
                      ),
                    ),
                    FormBuilderColorPickerField(
                      name: 'color_picker',
                      initialValue: Colors.yellow,
                      onChanged: _onChanged,
                      colorPickerType: ColorPickerType.materialPicker,
                      decoration: const InputDecoration(
                        labelText: 'Color Picker',
                      ),
                    ),
                    FormBuilderCupertinoDateTimePicker(
                      name: 'date_time_picker',
                      initialValue: DateTime.now(),
                      onChanged: _onChanged,
                      decoration: const InputDecoration(
                        labelText: 'Cupertino Date Time Picker',
                      ),
                      inputType: CupertinoDateTimePickerInputType.both,
                      locale: const Locale.fromSubtags(languageCode: 'id'),
                    ),
                    FormBuilderCupertinoDateTimePicker(
                      name: 'date-only',
                      initialValue: DateTime.now(),
                      onChanged: _onChanged,
                      inputType: CupertinoDateTimePickerInputType.date,
                      decoration: const InputDecoration(
                        labelText: 'Cupertino Date Only',
                      ),
                      locale: const Locale.fromSubtags(languageCode: 'id'),
                    ),
                    FormBuilderTypeAhead<String>(
                      name: 'continent',
                      itemBuilder: (context, country) {
                        return ListTile(
                          title: Text(country),
                        );
                      },
                      onChanged: _onChanged,
                      suggestionsCallback: (query) {
                        if (query.isNotEmpty) {
                          var lowercaseQuery = query.toLowerCase();
                          return country.where((country) {
                            return country.toLowerCase().contains(lowercaseQuery);
                          }).toList(growable: false)
                            ..sort((a, b) => a.toLowerCase().indexOf(lowercaseQuery).compareTo(
                                  b.toLowerCase().indexOf(lowercaseQuery),
                                ));
                        } else {
                          return country;
                        }
                      },
                    ),
                    FormBuilderTouchSpin(
                      name: 'touch_spin',
                      initialValue: 10,
                      decoration: const InputDecoration(
                        labelText: 'TouchSpin',
                      ),
                      step: 1,
                      onChanged: _onChanged,
                      iconSize: 48.0,
                      addIcon: const Icon(Icons.arrow_right),
                      subtractIcon: const Icon(Icons.arrow_left),
                    ),
                    FormBuilderRatingBar(
                      name: 'rate',
                      decoration: const InputDecoration(labelText: 'Rating'),
                      itemSize: 32.0,
                      onChanged: _onChanged,
                      initialValue: 1.5,
                      maxRating: 5.0,
                      ratingWidget: RatingWidget(
                        full: const Icon(Icons.star, color: Colors.amber),
                        half: const Icon(Icons.star_half, color: Colors.amber),
                        empty: const Icon(Icons.star_border, color: Colors.amber),
                      ),
                      unratedColor: Colors.yellow,
                    ),
                    FormBuilderSignaturePad(
                      name: 'signature',
                      onChanged: _onChanged,
                      decoration: const InputDecoration(labelText: 'Signature Pad'),
                      border: Border.all(color: Colors.green),
                    ),
                    FormBuilderCheckboxGroup<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(labelText: 'The Language of my people'),
                      name: 'languages',
                      options: const [
                        FormBuilderFieldOption(value: 'Dart'),
                        FormBuilderFieldOption(value: 'Swift'),
                        FormBuilderFieldOption(value: 'Kotlin'),
                        FormBuilderFieldOption(value: 'Java'),
                        FormBuilderFieldOption(value: 'PHP'),
                        FormBuilderFieldOption(value: 'Objective-C'),
                      ],
                      onChanged: _onChanged,
                      separator: const VerticalDivider(
                        width: 10,
                        thickness: 5,
                        color: Colors.red,
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.minLength(1),
                        FormBuilderValidators.maxLength(3),
                      ]),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState?.saveAndValidate() ?? false) {
                              debugPrint(_formKey.currentState?.value.toString());
                            } else {
                              debugPrint(_formKey.currentState?.value.toString());
                              debugPrint('validation failed');
                            }
                          },
                          child: const Text(
                            'Submit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            _formKey.currentState?.reset();
                          },
                          child: Text(
                            'Reset',
                            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final getPathImage = _formKey.currentState!.fields['image_picker']!.value;
                            final forEachImage = getPathImage.map((image) => image.path).toList();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('$forEachImage'),
                            ));
                          },
                          child: const Text('Get Path Image'),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final getPathFile = _formKey.currentState!.fields['file_picker']!.value;
                            final forEachFile = getPathFile.map((file) => file.path).toList();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('$forEachFile'),
                            ));
                          },
                          child: const Text('Get Path File'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
