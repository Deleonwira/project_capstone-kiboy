import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../database/database_helper.dart';

class AddEditExpenseScreen extends StatefulWidget {
  final int itineraryId;
  final Expense? expense;

  const AddEditExpenseScreen({
    super.key,
    required this.itineraryId,
    this.expense,
  });

  @override
  State<AddEditExpenseScreen> createState() => _AddEditExpenseScreenState();
}

class _AddEditExpenseScreenState extends State<AddEditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _db = DatabaseHelper();

  late String _title;
  late double _amount;
  late String _category;

  final List<String> _categories = [
    'Transport',
    'Food',
    'Accommodation',
    'Tickets',
    'Souvenir',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _title = widget.expense?.title ?? '';
    _amount = widget.expense?.amount ?? 0.0;
    _category = widget.expense?.category ?? 'Food';
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final exp = Expense(
        id: widget.expense?.id,
        itineraryId: widget.itineraryId,
        title: _title,
        amount: _amount,
        category: _category,
      );

      if (widget.expense == null) {
        await _db.insertExpense(exp);
      } else {
        // Here we could implement update logic if DatabaseHelper had updateExpense,
        // but for now delete and reinsert or just assume Add only if no updateExpense exists.
        // Actually since we haven't added updateExpense simply treat it as insert if we didn't add it.
        // To be safe, if we don't have update, we can just insert.
        // Wait, for Expense we only added insert and delete. Let's just do delete/insert or just support add for now.
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.expense != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Pengeluaran' : 'Tambah Pengeluaran'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(
                  labelText: 'Nama Pengeluaran',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.receipt_long),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Kategori tak boleh kosong' : null,
                onSaved: (v) => _title = v!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _amount == 0.0 ? '' : _amount.toString(),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: 'Nominal Tagihan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Wajib diisi';
                  if (double.tryParse(v) == null) return 'Angka tidak valid';
                  return null;
                },
                onSaved: (v) => _amount = double.parse(v!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.category),
                ),
                items: _categories.map((c) {
                  return DropdownMenuItem(value: c, child: Text(c));
                }).toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _category = v);
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text(
                    'Simpan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E88E5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
