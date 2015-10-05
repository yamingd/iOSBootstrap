// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: PAppResponse.proto

#define INTERNAL_SUPPRESS_PROTOBUF_FIELD_DEPRECATION
#include "PAppResponse.pb.hh"

#include <algorithm>

#include <google/protobuf/stubs/common.h>
#include <google/protobuf/stubs/once.h>
#include <google/protobuf/io/coded_stream.h>
#include <google/protobuf/wire_format_lite_inl.h>
#include <google/protobuf/descriptor.h>
#include <google/protobuf/generated_message_reflection.h>
#include <google/protobuf/reflection_ops.h>
#include <google/protobuf/wire_format.h>
// @@protoc_insertion_point(includes)

namespace {

const ::google::protobuf::Descriptor* PAppResponse_descriptor_ = NULL;
const ::google::protobuf::internal::GeneratedMessageReflection*
  PAppResponse_reflection_ = NULL;

}  // namespace


void protobuf_AssignDesc_PAppResponse_2eproto() {
  protobuf_AddDesc_PAppResponse_2eproto();
  const ::google::protobuf::FileDescriptor* file =
    ::google::protobuf::DescriptorPool::generated_pool()->FindFileByName(
      "PAppResponse.proto");
  GOOGLE_CHECK(file != NULL);
  PAppResponse_descriptor_ = file->message_type(0);
  static const int PAppResponse_offsets_[7] = {
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(PAppResponse, msg_),
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(PAppResponse, sessionid_),
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(PAppResponse, version_),
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(PAppResponse, code_),
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(PAppResponse, total_),
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(PAppResponse, data_),
    GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(PAppResponse, errors_),
  };
  PAppResponse_reflection_ =
    new ::google::protobuf::internal::GeneratedMessageReflection(
      PAppResponse_descriptor_,
      PAppResponse::default_instance_,
      PAppResponse_offsets_,
      GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(PAppResponse, _has_bits_[0]),
      GOOGLE_PROTOBUF_GENERATED_MESSAGE_FIELD_OFFSET(PAppResponse, _unknown_fields_),
      -1,
      ::google::protobuf::DescriptorPool::generated_pool(),
      ::google::protobuf::MessageFactory::generated_factory(),
      sizeof(PAppResponse));
}

namespace {

GOOGLE_PROTOBUF_DECLARE_ONCE(protobuf_AssignDescriptors_once_);
inline void protobuf_AssignDescriptorsOnce() {
  ::google::protobuf::GoogleOnceInit(&protobuf_AssignDescriptors_once_,
                 &protobuf_AssignDesc_PAppResponse_2eproto);
}

void protobuf_RegisterTypes(const ::std::string&) {
  protobuf_AssignDescriptorsOnce();
  ::google::protobuf::MessageFactory::InternalRegisterGeneratedMessage(
    PAppResponse_descriptor_, &PAppResponse::default_instance());
}

}  // namespace

void protobuf_ShutdownFile_PAppResponse_2eproto() {
  delete PAppResponse::default_instance_;
  delete PAppResponse_reflection_;
}

void protobuf_AddDesc_PAppResponse_2eproto() {
  static bool already_here = false;
  if (already_here) return;
  already_here = true;
  GOOGLE_PROTOBUF_VERIFY_VERSION;

  ::google::protobuf::DescriptorPool::InternalAddGeneratedFile(
    "\n\022PAppResponse.proto\"z\n\014PAppResponse\022\013\n\003"
    "msg\030\001 \001(\t\022\021\n\tsessionId\030\002 \001(\t\022\017\n\007version\030"
    "\003 \001(\005\022\014\n\004code\030\004 \002(\005\022\r\n\005total\030\005 \001(\005\022\014\n\004da"
    "ta\030\006 \003(\014\022\016\n\006errors\030\007 \003(\tB,\n\025com.argo.sdk"
    ".protobufB\021PAppResponseProtoP\001", 190);
  ::google::protobuf::MessageFactory::InternalRegisterGeneratedFile(
    "PAppResponse.proto", &protobuf_RegisterTypes);
  PAppResponse::default_instance_ = new PAppResponse();
  PAppResponse::default_instance_->InitAsDefaultInstance();
  ::google::protobuf::internal::OnShutdown(&protobuf_ShutdownFile_PAppResponse_2eproto);
}

// Force AddDescriptors() to be called at static initialization time.
struct StaticDescriptorInitializer_PAppResponse_2eproto {
  StaticDescriptorInitializer_PAppResponse_2eproto() {
    protobuf_AddDesc_PAppResponse_2eproto();
  }
} static_descriptor_initializer_PAppResponse_2eproto_;

// ===================================================================

#ifndef _MSC_VER
const int PAppResponse::kMsgFieldNumber;
const int PAppResponse::kSessionIdFieldNumber;
const int PAppResponse::kVersionFieldNumber;
const int PAppResponse::kCodeFieldNumber;
const int PAppResponse::kTotalFieldNumber;
const int PAppResponse::kDataFieldNumber;
const int PAppResponse::kErrorsFieldNumber;
#endif  // !_MSC_VER

PAppResponse::PAppResponse()
  : ::google::protobuf::Message() {
  SharedCtor();
}

void PAppResponse::InitAsDefaultInstance() {
}

PAppResponse::PAppResponse(const PAppResponse& from)
  : ::google::protobuf::Message() {
  SharedCtor();
  MergeFrom(from);
}

void PAppResponse::SharedCtor() {
  _cached_size_ = 0;
  msg_ = const_cast< ::std::string*>(&::google::protobuf::internal::kEmptyString);
  sessionid_ = const_cast< ::std::string*>(&::google::protobuf::internal::kEmptyString);
  version_ = 0;
  code_ = 0;
  total_ = 0;
  ::memset(_has_bits_, 0, sizeof(_has_bits_));
}

PAppResponse::~PAppResponse() {
  SharedDtor();
}

void PAppResponse::SharedDtor() {
  if (msg_ != &::google::protobuf::internal::kEmptyString) {
    delete msg_;
  }
  if (sessionid_ != &::google::protobuf::internal::kEmptyString) {
    delete sessionid_;
  }
  if (this != default_instance_) {
  }
}

void PAppResponse::SetCachedSize(int size) const {
  GOOGLE_SAFE_CONCURRENT_WRITES_BEGIN();
  _cached_size_ = size;
  GOOGLE_SAFE_CONCURRENT_WRITES_END();
}
const ::google::protobuf::Descriptor* PAppResponse::descriptor() {
  protobuf_AssignDescriptorsOnce();
  return PAppResponse_descriptor_;
}

const PAppResponse& PAppResponse::default_instance() {
  if (default_instance_ == NULL) protobuf_AddDesc_PAppResponse_2eproto();
  return *default_instance_;
}

PAppResponse* PAppResponse::default_instance_ = NULL;

PAppResponse* PAppResponse::New() const {
  return new PAppResponse;
}

void PAppResponse::Clear() {
  if (_has_bits_[0 / 32] & (0xffu << (0 % 32))) {
    if (has_msg()) {
      if (msg_ != &::google::protobuf::internal::kEmptyString) {
        msg_->clear();
      }
    }
    if (has_sessionid()) {
      if (sessionid_ != &::google::protobuf::internal::kEmptyString) {
        sessionid_->clear();
      }
    }
    version_ = 0;
    code_ = 0;
    total_ = 0;
  }
  data_.Clear();
  errors_.Clear();
  ::memset(_has_bits_, 0, sizeof(_has_bits_));
  mutable_unknown_fields()->Clear();
}

bool PAppResponse::MergePartialFromCodedStream(
    ::google::protobuf::io::CodedInputStream* input) {
#define DO_(EXPRESSION) if (!(EXPRESSION)) return false
  ::google::protobuf::uint32 tag;
  while ((tag = input->ReadTag()) != 0) {
    switch (::google::protobuf::internal::WireFormatLite::GetTagFieldNumber(tag)) {
      // optional string msg = 1;
      case 1: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_LENGTH_DELIMITED) {
          DO_(::google::protobuf::internal::WireFormatLite::ReadString(
                input, this->mutable_msg()));
          ::google::protobuf::internal::WireFormat::VerifyUTF8String(
            this->msg().data(), this->msg().length(),
            ::google::protobuf::internal::WireFormat::PARSE);
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectTag(18)) goto parse_sessionId;
        break;
      }

      // optional string sessionId = 2;
      case 2: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_LENGTH_DELIMITED) {
         parse_sessionId:
          DO_(::google::protobuf::internal::WireFormatLite::ReadString(
                input, this->mutable_sessionid()));
          ::google::protobuf::internal::WireFormat::VerifyUTF8String(
            this->sessionid().data(), this->sessionid().length(),
            ::google::protobuf::internal::WireFormat::PARSE);
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectTag(24)) goto parse_version;
        break;
      }

      // optional int32 version = 3;
      case 3: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_VARINT) {
         parse_version:
          DO_((::google::protobuf::internal::WireFormatLite::ReadPrimitive<
                   ::google::protobuf::int32, ::google::protobuf::internal::WireFormatLite::TYPE_INT32>(
                 input, &version_)));
          set_has_version();
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectTag(32)) goto parse_code;
        break;
      }

      // required int32 code = 4;
      case 4: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_VARINT) {
         parse_code:
          DO_((::google::protobuf::internal::WireFormatLite::ReadPrimitive<
                   ::google::protobuf::int32, ::google::protobuf::internal::WireFormatLite::TYPE_INT32>(
                 input, &code_)));
          set_has_code();
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectTag(40)) goto parse_total;
        break;
      }

      // optional int32 total = 5;
      case 5: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_VARINT) {
         parse_total:
          DO_((::google::protobuf::internal::WireFormatLite::ReadPrimitive<
                   ::google::protobuf::int32, ::google::protobuf::internal::WireFormatLite::TYPE_INT32>(
                 input, &total_)));
          set_has_total();
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectTag(50)) goto parse_data;
        break;
      }

      // repeated bytes data = 6;
      case 6: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_LENGTH_DELIMITED) {
         parse_data:
          DO_(::google::protobuf::internal::WireFormatLite::ReadBytes(
                input, this->add_data()));
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectTag(50)) goto parse_data;
        if (input->ExpectTag(58)) goto parse_errors;
        break;
      }

      // repeated string errors = 7;
      case 7: {
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_LENGTH_DELIMITED) {
         parse_errors:
          DO_(::google::protobuf::internal::WireFormatLite::ReadString(
                input, this->add_errors()));
          ::google::protobuf::internal::WireFormat::VerifyUTF8String(
            this->errors(this->errors_size() - 1).data(),
            this->errors(this->errors_size() - 1).length(),
            ::google::protobuf::internal::WireFormat::PARSE);
        } else {
          goto handle_uninterpreted;
        }
        if (input->ExpectTag(58)) goto parse_errors;
        if (input->ExpectAtEnd()) return true;
        break;
      }

      default: {
      handle_uninterpreted:
        if (::google::protobuf::internal::WireFormatLite::GetTagWireType(tag) ==
            ::google::protobuf::internal::WireFormatLite::WIRETYPE_END_GROUP) {
          return true;
        }
        DO_(::google::protobuf::internal::WireFormat::SkipField(
              input, tag, mutable_unknown_fields()));
        break;
      }
    }
  }
  return true;
#undef DO_
}

void PAppResponse::SerializeWithCachedSizes(
    ::google::protobuf::io::CodedOutputStream* output) const {
  // optional string msg = 1;
  if (has_msg()) {
    ::google::protobuf::internal::WireFormat::VerifyUTF8String(
      this->msg().data(), this->msg().length(),
      ::google::protobuf::internal::WireFormat::SERIALIZE);
    ::google::protobuf::internal::WireFormatLite::WriteString(
      1, this->msg(), output);
  }

  // optional string sessionId = 2;
  if (has_sessionid()) {
    ::google::protobuf::internal::WireFormat::VerifyUTF8String(
      this->sessionid().data(), this->sessionid().length(),
      ::google::protobuf::internal::WireFormat::SERIALIZE);
    ::google::protobuf::internal::WireFormatLite::WriteString(
      2, this->sessionid(), output);
  }

  // optional int32 version = 3;
  if (has_version()) {
    ::google::protobuf::internal::WireFormatLite::WriteInt32(3, this->version(), output);
  }

  // required int32 code = 4;
  if (has_code()) {
    ::google::protobuf::internal::WireFormatLite::WriteInt32(4, this->code(), output);
  }

  // optional int32 total = 5;
  if (has_total()) {
    ::google::protobuf::internal::WireFormatLite::WriteInt32(5, this->total(), output);
  }

  // repeated bytes data = 6;
  for (int i = 0; i < this->data_size(); i++) {
    ::google::protobuf::internal::WireFormatLite::WriteBytes(
      6, this->data(i), output);
  }

  // repeated string errors = 7;
  for (int i = 0; i < this->errors_size(); i++) {
  ::google::protobuf::internal::WireFormat::VerifyUTF8String(
    this->errors(i).data(), this->errors(i).length(),
    ::google::protobuf::internal::WireFormat::SERIALIZE);
    ::google::protobuf::internal::WireFormatLite::WriteString(
      7, this->errors(i), output);
  }

  if (!unknown_fields().empty()) {
    ::google::protobuf::internal::WireFormat::SerializeUnknownFields(
        unknown_fields(), output);
  }
}

::google::protobuf::uint8* PAppResponse::SerializeWithCachedSizesToArray(
    ::google::protobuf::uint8* target) const {
  // optional string msg = 1;
  if (has_msg()) {
    ::google::protobuf::internal::WireFormat::VerifyUTF8String(
      this->msg().data(), this->msg().length(),
      ::google::protobuf::internal::WireFormat::SERIALIZE);
    target =
      ::google::protobuf::internal::WireFormatLite::WriteStringToArray(
        1, this->msg(), target);
  }

  // optional string sessionId = 2;
  if (has_sessionid()) {
    ::google::protobuf::internal::WireFormat::VerifyUTF8String(
      this->sessionid().data(), this->sessionid().length(),
      ::google::protobuf::internal::WireFormat::SERIALIZE);
    target =
      ::google::protobuf::internal::WireFormatLite::WriteStringToArray(
        2, this->sessionid(), target);
  }

  // optional int32 version = 3;
  if (has_version()) {
    target = ::google::protobuf::internal::WireFormatLite::WriteInt32ToArray(3, this->version(), target);
  }

  // required int32 code = 4;
  if (has_code()) {
    target = ::google::protobuf::internal::WireFormatLite::WriteInt32ToArray(4, this->code(), target);
  }

  // optional int32 total = 5;
  if (has_total()) {
    target = ::google::protobuf::internal::WireFormatLite::WriteInt32ToArray(5, this->total(), target);
  }

  // repeated bytes data = 6;
  for (int i = 0; i < this->data_size(); i++) {
    target = ::google::protobuf::internal::WireFormatLite::
      WriteBytesToArray(6, this->data(i), target);
  }

  // repeated string errors = 7;
  for (int i = 0; i < this->errors_size(); i++) {
    ::google::protobuf::internal::WireFormat::VerifyUTF8String(
      this->errors(i).data(), this->errors(i).length(),
      ::google::protobuf::internal::WireFormat::SERIALIZE);
    target = ::google::protobuf::internal::WireFormatLite::
      WriteStringToArray(7, this->errors(i), target);
  }

  if (!unknown_fields().empty()) {
    target = ::google::protobuf::internal::WireFormat::SerializeUnknownFieldsToArray(
        unknown_fields(), target);
  }
  return target;
}

int PAppResponse::ByteSize() const {
  int total_size = 0;

  if (_has_bits_[0 / 32] & (0xffu << (0 % 32))) {
    // optional string msg = 1;
    if (has_msg()) {
      total_size += 1 +
        ::google::protobuf::internal::WireFormatLite::StringSize(
          this->msg());
    }

    // optional string sessionId = 2;
    if (has_sessionid()) {
      total_size += 1 +
        ::google::protobuf::internal::WireFormatLite::StringSize(
          this->sessionid());
    }

    // optional int32 version = 3;
    if (has_version()) {
      total_size += 1 +
        ::google::protobuf::internal::WireFormatLite::Int32Size(
          this->version());
    }

    // required int32 code = 4;
    if (has_code()) {
      total_size += 1 +
        ::google::protobuf::internal::WireFormatLite::Int32Size(
          this->code());
    }

    // optional int32 total = 5;
    if (has_total()) {
      total_size += 1 +
        ::google::protobuf::internal::WireFormatLite::Int32Size(
          this->total());
    }

  }
  // repeated bytes data = 6;
  total_size += 1 * this->data_size();
  for (int i = 0; i < this->data_size(); i++) {
    total_size += ::google::protobuf::internal::WireFormatLite::BytesSize(
      this->data(i));
  }

  // repeated string errors = 7;
  total_size += 1 * this->errors_size();
  for (int i = 0; i < this->errors_size(); i++) {
    total_size += ::google::protobuf::internal::WireFormatLite::StringSize(
      this->errors(i));
  }

  if (!unknown_fields().empty()) {
    total_size +=
      ::google::protobuf::internal::WireFormat::ComputeUnknownFieldsSize(
        unknown_fields());
  }
  GOOGLE_SAFE_CONCURRENT_WRITES_BEGIN();
  _cached_size_ = total_size;
  GOOGLE_SAFE_CONCURRENT_WRITES_END();
  return total_size;
}

void PAppResponse::MergeFrom(const ::google::protobuf::Message& from) {
  GOOGLE_CHECK_NE(&from, this);
  const PAppResponse* source =
    ::google::protobuf::internal::dynamic_cast_if_available<const PAppResponse*>(
      &from);
  if (source == NULL) {
    ::google::protobuf::internal::ReflectionOps::Merge(from, this);
  } else {
    MergeFrom(*source);
  }
}

void PAppResponse::MergeFrom(const PAppResponse& from) {
  GOOGLE_CHECK_NE(&from, this);
  data_.MergeFrom(from.data_);
  errors_.MergeFrom(from.errors_);
  if (from._has_bits_[0 / 32] & (0xffu << (0 % 32))) {
    if (from.has_msg()) {
      set_msg(from.msg());
    }
    if (from.has_sessionid()) {
      set_sessionid(from.sessionid());
    }
    if (from.has_version()) {
      set_version(from.version());
    }
    if (from.has_code()) {
      set_code(from.code());
    }
    if (from.has_total()) {
      set_total(from.total());
    }
  }
  mutable_unknown_fields()->MergeFrom(from.unknown_fields());
}

void PAppResponse::CopyFrom(const ::google::protobuf::Message& from) {
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

void PAppResponse::CopyFrom(const PAppResponse& from) {
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

bool PAppResponse::IsInitialized() const {
  if ((_has_bits_[0] & 0x00000008) != 0x00000008) return false;

  return true;
}

void PAppResponse::Swap(PAppResponse* other) {
  if (other != this) {
    std::swap(msg_, other->msg_);
    std::swap(sessionid_, other->sessionid_);
    std::swap(version_, other->version_);
    std::swap(code_, other->code_);
    std::swap(total_, other->total_);
    data_.Swap(&other->data_);
    errors_.Swap(&other->errors_);
    std::swap(_has_bits_[0], other->_has_bits_[0]);
    _unknown_fields_.Swap(&other->_unknown_fields_);
    std::swap(_cached_size_, other->_cached_size_);
  }
}

::google::protobuf::Metadata PAppResponse::GetMetadata() const {
  protobuf_AssignDescriptorsOnce();
  ::google::protobuf::Metadata metadata;
  metadata.descriptor = PAppResponse_descriptor_;
  metadata.reflection = PAppResponse_reflection_;
  return metadata;
}


// @@protoc_insertion_point(namespace_scope)

// @@protoc_insertion_point(global_scope)
