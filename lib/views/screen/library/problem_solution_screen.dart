import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extension/controller/library_controller.dart';
import 'package:flutter_extension/data/model/library_file_model.dart';
import 'package:flutter_extension/data/model/library_image_model.dart';
import 'package:flutter_extension/data/model/library_note_model.dart';
import 'package:flutter_extension/util/app_colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

String _psDateLabel(String iso) {
  final t = iso.indexOf('T');
  if (t > 0) return iso.substring(0, t);
  if (iso.length >= 10) return iso.substring(0, 10);
  return iso.isEmpty ? '—' : iso;
}

String _psSubjectLabel(String raw) {
  final s = raw.trim().toLowerCase();
  if (s.isEmpty) return '—';
  return s[0].toUpperCase() + (s.length > 1 ? s.substring(1) : '');
}

String _psFormatFileSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  final kb = bytes / 1024;
  if (kb < 1024) {
    return kb < 10 ? '${kb.toStringAsFixed(1)} KB' : '${kb.round()} KB';
  }
  final mb = kb / 1024;
  return mb < 10 ? '${mb.toStringAsFixed(1)} MB' : '${mb.round()} MB';
}

/// Detail view for a library note, image, or file — GET detail API; shows all fields except `ai_response`.
class ProblemSolutionScreen extends StatefulWidget {
  const ProblemSolutionScreen({
    super.key,
    required this.id,
    required this.itemType,
  });

  /// Resource id from the list item.
  final String id;

  /// [LibraryItem.type]: `note`, `image`, or `upload` (file).
  final String itemType;

  @override
  State<ProblemSolutionScreen> createState() => _ProblemSolutionScreenState();
}

class _ProblemSolutionScreenState extends State<ProblemSolutionScreen> {
  late final LibraryController _libraryController;

  bool _loading = true;
  String? _error;
  LibraryNoteModel? _note;
  LibraryImageModel? _image;
  LibraryFileModel? _file;

  @override
  void initState() {
    super.initState();
    _libraryController = Get.find<LibraryController>();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
      _note = null;
      _image = null;
      _file = null;
    });
    final r = await _libraryController.fetchLibraryItemDetail(
      id: widget.id,
      type: widget.itemType,
    );
    if (!mounted) return;
    setState(() {
      _loading = false;
      _error = r.error;
      _note = r.note;
      _image = r.image;
      _file = r.file;
    });
  }

  String _headerTitle() {
    if (_note != null) {
      return _note!.title.trim().isEmpty ? 'Untitled note' : _note!.title;
    }
    if (_image != null) {
      return _image!.title.trim().isEmpty ? 'Untitled image' : _image!.title;
    }
    if (_file != null) {
      return _file!.title.trim().isEmpty ? 'Untitled file' : _file!.title;
    }
    return 'Problem solution';
  }

  String _subjectLine() {
    if (_note != null) {
      return _psSubjectLabel(_note!.subject);
    }
    if (_image != null) {
      return _psSubjectLabel(_image!.subject);
    }
    if (_file != null) {
      return _psSubjectLabel(_file!.subject);
    }
    return '';
  }

  String _kindLabel() {
    switch (widget.itemType) {
      case 'note':
        return 'Note';
      case 'image':
        return 'Image';
      case 'upload':
        return 'File';
      default:
        return 'Item';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
              onTap: Get.back,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.textColor.withValues(alpha: 0.04),
                ),
                child: Center(
                  child: Icon(Icons.arrow_back, color: AppColors.textColor),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _loading ? 'Loading…' : _headerTitle(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _loading || _error != null
                        ? 'Library'
                        : '${_subjectLine()} · ${_kindLabel()}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textColor.withValues(alpha: 0.40),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFA78BFA)),
              )
            : _error != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _error!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textColor.withValues(alpha: 0.70),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: _load,
                        child: Text(
                          'Retry',
                          style: TextStyle(
                            color: AppColors.textColor.withValues(alpha: 0.90),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_note != null) _buildNoteDetail(_note!),
                    if (_image != null) _buildImageDetail(_image!),
                    if (_file != null) _buildFileDetail(_file!),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _detailMetaRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 108,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textColor.withValues(alpha: 0.45),
              ),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: TextStyle(
                fontSize: 13,
                height: 1.35,
                color: AppColors.textColor.withValues(alpha: 0.88),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteDetail(LibraryNoteModel n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFA78BFA).withValues(alpha: 0.08),
        border: Border.all(
          color: const Color(0xFFA78BFA).withValues(alpha: 0.20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Note',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
              color: AppColors.textColor.withValues(alpha: 0.40),
            ),
          ),
          const SizedBox(height: 12),
          _detailMetaRow('Subject', _psSubjectLabel(n.subject)),
          _detailMetaRow(
            'Created',
            _psDateLabel(n.createdAt),
          ),
          _detailMetaRow(
            'Updated',
            _psDateLabel(n.updatedAt),
          ),
          if (n.folderId != null && n.folderId!.trim().isNotEmpty)
            _detailMetaRow('Folder ID', n.folderId!.trim()),
          const SizedBox(height: 8),
          Text(
            'Text',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
              color: AppColors.textColor.withValues(alpha: 0.40),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            n.text.trim().isEmpty ? '—' : n.text,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 1.45,
              color: AppColors.textColor,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SvgPicture.asset('assets/icon/right.svg'),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${_psSubjectLabel(n.subject)} · Note',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF34D399),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageDetail(LibraryImageModel img) {
    const accent = Color(0xFF10B981);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: accent.withValues(alpha: 0.08),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Image',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
              color: AppColors.textColor.withValues(alpha: 0.40),
            ),
          ),
          const SizedBox(height: 12),
          _detailMetaRow('Subject', _psSubjectLabel(img.subject)),
          _detailMetaRow(
            'Size',
            _psFormatFileSize(img.fileSizeBytes),
          ),
          _detailMetaRow(
            'Created',
            _psDateLabel(img.createdAt),
          ),
          if (img.folderId != null && img.folderId!.trim().isNotEmpty)
            _detailMetaRow('Folder ID', img.folderId!.trim()),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 10,
              child: img.imageUrl.isEmpty
                  ? ColoredBox(
                      color: accent.withValues(alpha: 0.12),
                      child: const Icon(
                        Icons.image_outlined,
                        color: accent,
                        size: 48,
                      ),
                    )
                  : CachedNetworkImage(
                      imageUrl: img.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => ColoredBox(
                        color: AppColors.textColor.withValues(alpha: 0.06),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFA78BFA),
                          ),
                        ),
                      ),
                      errorWidget: (_, __, ___) => ColoredBox(
                        color: accent.withValues(alpha: 0.12),
                        child: const Icon(
                          Icons.broken_image_outlined,
                          color: accent,
                          size: 48,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileDetail(LibraryFileModel f) {
    const accent = Color(0xFF34D399);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: accent.withValues(alpha: 0.08),
        border: Border.all(color: accent.withValues(alpha: 0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'File',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
              color: AppColors.textColor.withValues(alpha: 0.40),
            ),
          ),
          const SizedBox(height: 12),
          _detailMetaRow('Subject', _psSubjectLabel(f.subject)),
          if (f.originalFilename.isNotEmpty)
            _detailMetaRow('Original name', f.originalFilename),
          _detailMetaRow(
            'Size',
            _psFormatFileSize(f.fileSizeBytes),
          ),
          _detailMetaRow(
            'Created',
            _psDateLabel(f.createdAt),
          ),
          if (f.folderId != null && f.folderId!.trim().isNotEmpty)
            _detailMetaRow('Folder ID', f.folderId!.trim()),
          if (f.fileUrl.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'File URL',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
                color: AppColors.textColor.withValues(alpha: 0.40),
              ),
            ),
            const SizedBox(height: 6),
            SelectableText(
              f.fileUrl,
              style: const TextStyle(
                fontSize: 12,
                height: 1.4,
                color: Color(0xFF93C5FD),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
