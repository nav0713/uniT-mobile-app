import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:unit2/bloc/profile/primary_information/citizenship/citizenship_bloc.dart';
import 'package:unit2/model/profile/basic_information/citizenship.dart';
import 'package:unit2/screens/profile/components/basic_information/citizenship/loading.dart';
import 'package:unit2/theme-data.dart/btn-style.dart';
import 'package:unit2/theme-data.dart/colors.dart';
import 'package:unit2/utils/global.dart';
import 'package:unit2/utils/text_container.dart';
import 'package:unit2/widgets/Leadings/add_leading.dart';
import 'package:unit2/widgets/error_state.dart';

import '../../../../model/location/country.dart';
import '../../../../theme-data.dart/form-style.dart';
import '../../../../utils/alerts.dart';

class CitizenShipScreen extends StatefulWidget {
  final int profileId;
  final String token;
  final List<Citizenship> citizenships;
  const CitizenShipScreen(
      {super.key, required this.profileId, required this.token , required this.citizenships});

  @override
  State<CitizenShipScreen> createState() => _CitizenShipScreenState();
}

List<Country> countries = [];
bool naturalBorn = false;
Country? selectedCountry;
final formKey = GlobalKey<FormBuilderState>();

class _CitizenShipScreenState extends State<CitizenShipScreen> {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<CitizenshipBloc>(context);
    return ProgressHUD(
      padding: const EdgeInsets.all(24),
      indicatorWidget: const SpinKitFadingCircle(
        color: Colors.white,
      ),
      backgroundColor: Colors.black87,
      child: BlocConsumer<CitizenshipBloc, CitizenshipState>(
        listener: (context, state) {
          if (state is CitizenshipAddedState) {
            if (state.responseStatus['success']) {
              successAlert(
                  context, "Add Successfull!", state.responseStatus['message'],
                  () {
                Navigator.of(context).pop();
                context.read<CitizenshipBloc>().add(const LoadCitizenship());
              });
            } else {
               errorAlert(context, "Adding Failed",
                  "Something went wrong. Please try again.", () {
                Navigator.of(context).pop();
                context.read<CitizenshipBloc>().add(const LoadCitizenship());
              });
            }
          }

          if (state is CitizenshipEditedState) {
            if (state.responseStatus['success']) {
              successAlert(context, "Update Successfull!",
                  state.responseStatus['message'], () {
                Navigator.of(context).pop();
                context.read<CitizenshipBloc>().add(const LoadCitizenship());
              });
            } else {
              errorAlert(context, "Update Failed",
                       state.responseStatus['message'], () {
                Navigator.of(context).pop();
                context.read<CitizenshipBloc>().add(const LoadCitizenship());
              });
            }
          }

          ////DELETED STATE
          if (state is CitizenshipDeleltedState) {
            if (state.succcess) {
              successAlert(context, "Deletion Successfull",
                  "Contact Info has been deleted successfully", () {
                Navigator.of(context).pop();
                context.read<CitizenshipBloc>().add(const LoadCitizenship());
              });
            } else {
              errorAlert(
                  context, "Deletion Failed", "Error deleting Contact Info",
                  () {
                Navigator.of(context).pop();
                context.read<CitizenshipBloc>().add(const LoadCitizenship());
              });
            }
          }
        },
        builder: (context, state) {
          if (state is CitizenshipLoaded) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text(citizenshipScreenTitle),
                  centerTitle: true,
                  backgroundColor: primary,
                  actions: [
                    AddLeading(onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Add Citizenship"),
                              content: FormBuilder(
                                key: formKey,
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FormBuilderDropdown<Country>(
                                        initialValue: null,
                                        validator:
                                            FormBuilderValidators.required(
                                                errorText:
                                                    "This field is required"),
                                        items: state.countries
                                            .map<DropdownMenuItem<Country>>(
                                                (Country country) {
                                          return DropdownMenuItem<Country>(
                                              value: country,
                                              child: FittedBox(
                                                  child: Text(country.name!)));
                                        }).toList(),
                                        name: 'country',
                                        decoration: normalTextFieldStyle(
                                            "Country*", "Country"),
                                        onChanged: (Country? value) {
                                          selectedCountry = value;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      FormBuilderSwitch(
                                        initialValue: naturalBorn,
                                        activeColor: second,
                                        onChanged: (value) {
                                          setState(() {
                                            naturalBorn = value!;
                                          });
                                        },
                                        decoration: normalTextFieldStyle(
                                            "Natural Born?", 'Natural Born?'),
                                        name: 'graudated',
                                        title: Text(naturalBorn ? "YES" : "NO"),
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      SizedBox(
                                        width: double.infinity,
                                        height: 60,
                                        child: ElevatedButton(
                                            style: mainBtnStyle(primary,
                                                Colors.transparent, second),
                                            onPressed: () {
                                              if (formKey.currentState!
                                                  .saveAndValidate()) {
                                                Navigator.pop(context);
                                                bloc.add(AddCitizenship(
                                                    coiuntryId:
                                                        selectedCountry!.id!,
                                                    naturalBorn: naturalBorn,
                                                    profileId: widget.profileId,
                                                    token: widget.token));
                                              }
                                            },
                                            child: const Text(submit)),
                                      )
                                    ]),
                              ),
                            );
                          });
                    })
                  ],
                ),
                body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 24,
                        ),
                        child: SizedBox(
                          width: screenWidth,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Philippines",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: primary),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "Filipino",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ]),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(FontAwesome5.exclamation_circle),
                        title: Text(
                          "Your Filipino citizenship is added by default",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      const Divider(
                        height: 2,
                        thickness: 1,
                      ),
                      SizedBox(
                          child: state.citizenships.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Text(
                                    "If you have citizenships other than Filipino, kindly add in this section",
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                )
                              : SizedBox(
                                  height: screenHeight * .70,
                                  width: double.infinity,
                                  child: ListView(
                                    children: state.citizenships
                                        .map((e) => Card(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: ListTile(
                                                      dense: true,
                                                      title: Text(
                                                        e.country!.name!,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: primary),
                                                      ),
                                                      subtitle: Text(
                                                          e.naturalBorn!
                                                              ? "Natural Born"
                                                              : "Naturalized"),
                                                    ),
                                                  ),
                                                  AppPopupMenu<int>(
                                                    offset:
                                                        const Offset(-10, -10),
                                                    elevation: 3,
                                                    onSelected: (value) {
                                                      ////delete contact-= = = = = = = = =>>
                                                      if (value == 2) {
                                                        confirmAlert(context,
                                                            () {
                                                          context
                                                              .read<
                                                                  CitizenshipBloc>()
                                                              .add(DeleteCitizenship(
                                                                  coiuntryId: e
                                                                      .country!
                                                                      .id!,
                                                                  naturalBorn:
                                                                      e
                                                                          .naturalBorn!,
                                                                  profileId: widget
                                                                      .profileId,
                                                                  token: widget
                                                                      .token));
                                                        }, "Delete?",
                                                            "Are you sure you want to delete this contact info?");
                                                      }
                                                      if (value == 1) {
                                                        ////edit contact-= = = = = = = = =>>

                                                        showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              selectedCountry = state
                                                                  .countries
                                                                  .firstWhere((element) =>
                                                                      element
                                                                          .id ==
                                                                      e.country!
                                                                          .id);
                                                              return AlertDialog(
                                                                title: const Text(
                                                                    "Add Citizenship"),
                                                                content:
                                                                    FormBuilder(
                                                                  key: formKey,
                                                                  child: Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: [
                                                                        DropdownButtonFormField<
                                                                            Country>(
                                                                          isExpanded:
                                                                              true,
                                                                          value:
                                                                              selectedCountry,
                                                                          validator:
                                                                              FormBuilderValidators.required(errorText: "This field is required"),
                                                                          items: state
                                                                              .countries
                                                                              .map<DropdownMenuItem<Country>>((Country country) {
                                                                            return DropdownMenuItem<Country>(
                                                                                value: country,
                                                                                child: FittedBox(child: Text(country.name!)));
                                                                          }).toList(),
                                                                          decoration: normalTextFieldStyle(
                                                                              "Country*",
                                                                              "Country"),
                                                                          onChanged:
                                                                              (Country? value) {
                                                                            selectedCountry =
                                                                                value;
                                                                          },
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              12,
                                                                        ),
                                                                        FormBuilderSwitch(
                                                                          initialValue:
                                                                              e.naturalBorn,
                                                                          activeColor:
                                                                              second,
                                                                          onChanged:
                                                                              (value) {
                                                                            setState(() {
                                                                              naturalBorn = value!;
                                                                            });
                                                                          },
                                                                          decoration: normalTextFieldStyle(
                                                                              "Natural Born?",
                                                                              'Natural Born?'),
                                                                          name:
                                                                              'graudated',
                                                                          title: Text(naturalBorn
                                                                              ? "YES"
                                                                              : "NO"),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              12,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              double.infinity,
                                                                          height:
                                                                              60,
                                                                          child: ElevatedButton(
                                                                              style: mainBtnStyle(primary, Colors.transparent, second),
                                                                              onPressed: () {
                                                                                Citizenship newCitizenship = Citizenship(country: selectedCountry, naturalBorn: naturalBorn);
                                                                                if (formKey.currentState!.saveAndValidate()) {
                                                                                  Navigator.pop(context);
                                                                                  bloc.add(EditCitizenship(citizenship: newCitizenship, profileId: widget.profileId, token: widget.token,oldCountryId: e.country!.id!));
                                                                                }
                                                                              },
                                                                              child: const Text(submit)),
                                                                        )
                                                                      ]),
                                                                ),
                                                              );
                                                            });
                                                      }
                                                    },
                                                    menuItems: [
                                                      popMenuItem(
                                                          text: "Update",
                                                          value: 1,
                                                          icon: Icons.edit),
                                                      popMenuItem(
                                                          text: "Remove",
                                                          value: 2,
                                                          icon: Icons.delete),
                                                    ],
                                                    icon: const Icon(
                                                      Icons.more_vert,
                                                      color: Colors.grey,
                                                    ),
                                                    tooltip: "Options",
                                                  )
                                                ],
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                ))
                    ]));
          }
          if (state is CitizenshipLoadingState) {
            return const Scaffold(body: CitizenshipLoading());
          }
          if (state is CitizenshipErrorState) {
            return Scaffold(
                body: SomethingWentWrong(
                    message: state.message, onpressed: () {
                      context.read<CitizenshipBloc>().add(GetCitizenship(citizenship: widget.citizenships));
                    }));
          }
          return Container();
        },
      ),
    );
  }

  PopupMenuItem<int> popMenuItem({String? text, int? value, IconData? icon}) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            text!,
          ),
        ],
      ),
    );
  }
}
