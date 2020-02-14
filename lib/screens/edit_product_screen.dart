import 'package:app3_shop/providers/product.dart';
import 'package:app3_shop/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum InputType {
  Title,
  Price,
  Description,
  ImageUrl,
}

class EditProductScreen extends StatefulWidget {
  static const routeName = 'edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
  };
  var _isLoadingData = true;
  var _isSaving = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isLoadingData) {
      final productId = ModalRoute.of(context).settings.arguments as String;

      if (productId != null) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initValues['title'] = _editedProduct.title;
        _initValues['price'] = _editedProduct.price.toString();
        _initValues['description'] = _editedProduct.description;
        _imageUrlController.text = _editedProduct.imageUrl;
      }
      _isLoadingData = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _getInputData(String value, InputType inputType) {
    switch (inputType) {
      case InputType.Title:
        _editedProduct = Product(
          id: _editedProduct.id,
          title: value,
          price: _editedProduct.price,
          description: _editedProduct.description,
          imageUrl: _editedProduct.imageUrl,
          isFavorite: _editedProduct.isFavorite,
        );
        break;
      case InputType.Price:
        _editedProduct = Product(
          id: _editedProduct.id,
          title: _editedProduct.title,
          price: double.parse(value),
          description: _editedProduct.description,
          imageUrl: _editedProduct.imageUrl,
          isFavorite: _editedProduct.isFavorite,
        );
        break;
      case InputType.Description:
        _editedProduct = Product(
          id: _editedProduct.id,
          title: _editedProduct.title,
          price: _editedProduct.price,
          description: value,
          imageUrl: _editedProduct.imageUrl,
          isFavorite: _editedProduct.isFavorite,
        );
        break;
      case InputType.ImageUrl:
        _editedProduct = Product(
          id: _editedProduct.id,
          title: _editedProduct.title,
          price: _editedProduct.price,
          description: _editedProduct.description,
          imageUrl: value,
          isFavorite: _editedProduct.isFavorite,
        );
        break;
    }
  }

  Future<void> _saveForm() async {
    final _isValid = _form.currentState.validate();
    if (!_isValid) return;
    _form.currentState.save();
    setState(() {
      _isSaving = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editedProduct);
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (e) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('An error occurred'),
            content: Text(e.toString()),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isSaving = false;
    });
    Navigator.of(context).pop();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_validateImageUrl(_imageUrlController.text) == null) setState(() {});
    }
  }

  String _validateImageUrl(String value) {
    if (value.isEmpty) return 'Please provide a image URL';
    if (!value.startsWith('http')) return 'Please enter a valid URL';
    /*if (!value.endsWith('.png') &&
        !value.endsWith('.jpg') &&
        !value.endsWith('.jpeg'))
      return 'Please enter a valid image URL';*/
    return null;
  }

  String _validatePrice(String value) {
    if (value.isEmpty) return 'Please provide a price';
    if (double.tryParse(value) == null) return 'Please provide a valid price';
    if (double.parse(value) <= 0)
      return 'Please enter a number greater than zero';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveForm(),
          ),
        ],
      ),
      body: _isSaving
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: const InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_priceFocusNode),
                      validator: (value) {
                        if (value.isEmpty) return 'Please provide a title';
                        return null;
                      },
                      onSaved: (value) =>
                          this._getInputData(value, InputType.Title),
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: const InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode),
                      validator: (value) => this._validatePrice(value),
                      onSaved: (value) =>
                          this._getInputData(value, InputType.Price),
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_imageUrlFocusNode),
                      validator: (value) {
                        if (value.isEmpty)
                          return 'Please provide a description';
                        if (value.length < 10)
                          return 'Should be at least 10 caracteres';
                        return null;
                      },
                      onSaved: (value) =>
                          this._getInputData(value, InputType.Description),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) => _saveForm(),
                            validator: (value) => this._validateImageUrl(value),
                            onSaved: (value) =>
                                this._getInputData(value, InputType.ImageUrl),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
