##
# Sample Ruby delegate script containing stubs and documentation for all
# available delegate methods. See the user manual for more information.
#
# The application will create an instance of this class early in the request
# cycle and dispose of it at the end of the request cycle. Instances don't need
# to be thread-safe, but sharing information across instances (requests)
# **does** need to be done thread-safely.
#
# This version of the script works with Cantaloupe version >= 5.
#
class CustomDelegate

  ##
  # Attribute for the request context, which is a hash containing information
  # about the current request.
  #
  # This attribute will be set by the server before any other methods are
  # called. Methods can access its keys like:
  #
  # ```
  # identifier = context['identifier']
  # ```
  #
  # The hash will contain the following keys in response to all requests:
  #
  # * `client_ip`        [String] Client IP address.
  # * `cookies`          [Hash<String,String>] Hash of cookie name-value pairs.
  # * `full_size`        [Hash<String,Integer>] Hash with `width` and `height`
  #                      keys corresponding to the pixel dimensions of the
  #                      source image.
  # * `identifier`       [String] Image identifier.
  # * `local_uri`        [String] URI seen by the application, which may be
  #                      different from `request_uri` when operating behind a
  #                      reverse-proxy server.
  # * `metadata`         [Hash<String,Object>] Embedded image metadata. Object
  #                      structure varies depending on the source image.
  #                      See the `metadata()` method.
  # * `page_count`       [Integer] Page count.
  # * `page_number`      [Integer] Page number.
  # * `request_headers`  [Hash<String,String>] Hash of header name-value pairs.
  # * `request_uri`      [String] URI requested by the client.
  # * `scale_constraint` [Array<Integer>] Two-element array with scale
  #                      constraint numerator at position 0 and denominator at
  #                      position 1.
  #
  # It will contain the following additional string keys in response to image
  # requests, after the image has been accessed:
  #
  # * `operations`     [Array<Hash<String,Object>>] Array of operations in
  #                    order of application. Only operations that are not
  #                    no-ops will be included. Every hash contains a `class`
  #                    key corresponding to the operation class name, which
  #                    will be one of the `e.i.l.c.operation.Operation`
  #                    implementations.
  # * `output_format`  [String] Output format media (MIME) type.
  # * `resulting_size` [Hash<String,Integer>] Hash with `width` and `height`
  #                    keys corresponding to the pixel dimensions of the
  #                    resulting image after all operations have been applied.
  #
  # @return [Hash] Request context.
  #
  attr_accessor :context

  ##
  # Deserializes the given meta-identifier string into a hash of its component
  # parts.
  #
  # This method is used only when the `meta_identifier.transformer`
  # configuration key is set to `DelegateMetaIdentifierTransformer`.
  #
  # The hash contains the following keys:
  #
  # * `identifier`       [String] Required.
  # * `page_number`      [Integer] Optional.
  # * `scale_constraint` [Array<Integer>] Two-element array with scale
  #                      constraint numerator at position 0 and denominator at
  #                      position 1. Optional.
  #
  # @param meta_identifier [String]
  # @return Hash<String,Object> See above. The return value should be
  #                             compatible with the argument to
  #                             {serialize_meta_identifier}.
  #
  def deserialize_meta_identifier(meta_identifier)
  end

  ##
  # Serializes the given meta-identifier hash.
  #
  # This method is used only when the `meta_identifier.transformer`
  # configuration key is set to `DelegateMetaIdentifierTransformer`.
  #
  # See {deserialize_meta_identifier} for a description of the hash structure.
  #
  # @param components [Hash<String,Object>]
  # @return [String] Serialized meta-identifier compatible with the argument to
  #                  {deserialize_meta_identifier}.
  #
  def serialize_meta_identifier(components)
  end

  ##
  # Returns authorization status for the current request. This method is called
  # upon all requests to all public endpoints early in the request cycle,
  # before the image has been accessed. This means that some context keys (like
  # `full_size`) will not be available yet.
  #
  # This method should implement all possible authorization logic except that
  # which requires any of the context keys that aren't yet available. This will
  # ensure efficient authorization failures.
  #
  # Implementations should assume that the underlying resource is available,
  # and not try to check for it.
  #
  # Possible return values:
  #
  # 1. Boolean true/false, indicating whether the request is fully authorized
  #    or not. If false, the client will receive a 403 Forbidden response.
  # 2. Hash with a `status_code` key.
  #     a. If it corresponds to an integer from 200-299, the request is
  #        authorized.
  #     b. If it corresponds to an integer from 300-399:
  #         i. If the hash also contains a `location` key corresponding to a
  #            URI string, the request will be redirected to that URI using
  #            that code.
  #         ii. If the hash also contains `scale_numerator` and
  #            `scale_denominator` keys, the request will be
  #            redirected using that code to a virtual reduced-scale version of
  #            the source image.
  #     c. If it corresponds to 401, the hash must include a `challenge` key
  #        corresponding to a WWW-Authenticate header value.
  #
  # @param options [Hash] Empty hash.
  # @return [Boolean,Hash<String,Object>] See above.
  #
  def pre_authorize(options = {})
    true
  end

  ##
  # Returns authorization status for the current request. Will be called upon
  # all requests to all public image (not information) endpoints.
  #
  # This is a counterpart of `pre_authorize()` that is invoked later in the
  # request cycle, once more information about the underlying image has become
  # available. It should only contain logic that depends on context keys that
  # contain information about the source image (like `full_size`, `metadata`,
  # etc.)
  #
  # Implementations should assume that the underlying resource is available,
  # and not try to check for it.
  #
  # @param options [Hash] Empty hash.
  # @return [Boolean,Hash<String,Object>] See the documentation of
  #                                       `pre_authorize()`.
  #
  def authorize(options = {})
    true
  end

  ##
  # Adds additional keys to an Image API 2.x information response. See the
  # [IIIF Image API 2.1](http://iiif.io/api/image/2.1/#image-information)
  # specification and "endpoints" section of the user manual.
  #
  # @param options [Hash] Empty hash.
  # @return [Hash] Hash to merge into an Image API 2.x information response.
  #                Return an empty hash to add nothing.
  #
  def extra_iiif2_information_response_keys(options = {})
    {}
  end

  ##
  # Adds additional keys to an Image API 3.x information response. See the
  # [IIIF Image API 3.0](http://iiif.io/api/image/3.0/#image-information)
  # specification and "endpoints" section of the user manual.
  #
  # @param options [Hash] Empty hash.
  # @return [Hash] Hash to merge into an Image API 3.x information response.
  #                Return an empty hash to add nothing.
  #
  def extra_iiif3_information_response_keys(options = {})
    {}
  end

  ##
  # Tells the server which source to use for the given identifier.
  #
  # @param options [Hash] Empty hash.
  # @return [String] Source name.
  #
  def source(options = {})
  end

  ##
  # N.B.: this method should not try to perform authorization. `authorize()`
  # should be used instead.
  #
  # @param options [Hash] Empty hash.
  # @return [String,nil] Blob key of the image corresponding to the given
  #                      identifier, or nil if not found.
  #
  def azurestoragesource_blob_key(options = {})
  end

  ##
  # N.B.: this method should not try to perform authorization. `authorize()`
  # should be used instead.
  #
  # @param options [Hash] Empty hash.
  # @return [String,nil] Absolute pathname of the image corresponding to the
  #                      given identifier, or nil if not found.
  #
  def filesystemsource_pathname(options = {})
  end

  ##
  # Returns one of the following:
  #
  # 1. String URI
  # 2. Hash with the following keys:
  #     * `uri`      [String] (required)
  #     * `username` [String] For HTTP Basic authentication (optional).
  #     * `secret`   [String] For HTTP Basic authentication (optional).
  #     * `headers`  [Hash<String,String>] Hash of request headers (optional).
  # 3. nil if not found.
  #
  # N.B.: this method should not try to perform authorization. `authorize()`
  # should be used instead.
  #
  # @param options [Hash] Empty hash.
  # @return See above.
  #
  def httpsource_resource_info(options = {})
  end

  ##
  # N.B.: this method should not try to perform authorization. `authorize()`
  # should be used instead.
  #
  # @param options [Hash] Empty hash.
  # @return [String] Identifier of the image corresponding to the given
  #                  identifier in the database.
  #
  def jdbcsource_database_identifier(options = {})
  end

  ##
  # Returns either the media (MIME) type of an image, or an SQL statement that
  # can be used to retrieve it, if it is stored in the database. In the latter
  # case, the "SELECT" and "FROM" clauses should be in uppercase in order to
  # be autodetected. If nil is returned, the media type will be inferred some
  # other way, such as by identifier extension or magic bytes.
  #
  # @param options [Hash] Empty hash.
  # @return [String, nil]
  #
  def jdbcsource_media_type(options = {})
  end

  ##
  # @param options [Hash] Empty hash.
  # @return [String] SQL statement that selects the BLOB corresponding to the
  #                  value returned by `jdbcsource_database_identifier()`.
  #
  def jdbcsource_lookup_sql(options = {})
  end

  ##
  # N.B.: this method should not try to perform authorization. `authorize()`
  # should be used instead.
  #
  # @param options [Hash] Empty hash.
  # @return [Hash<String,Object>,nil] Hash containing `bucket` and `key` keys;
  #                                   or nil if not found.
  #

  def s3source_object_info(options = {})

     #context.each{ |k,v| puts "INFO: #{k}: #{v}" } 

     # get the extracted identifier
     id = context['identifier']

     # pull the target bucket names from the environment
     iiif_bucket = ENV['IIIF_BUCKET_NAME']
     mandala_bucket = ENV['MANDALA_BUCKET_NAME']

     #
     # Start with the most common cases
     #

     # look for uva-lib:nnnnn (5 digits)
     if match = id.match(/^uva-lib:([0-9][0-9])?([0-9][0-9])?([0-9])?$/)
        d1, d2, d3 = match.captures
        key    = "uva-lib/#{d1}/#{d2}/#{d3}/#{d1}#{d2}#{d3}.jp2"
        bucket = iiif_bucket
        puts "INFO: rewrite [#{id}] -> [s3://#{bucket}/#{key}]"
        return { "bucket" => bucket, "key" => key }
     end

     # look for uva-lib:nnnnnn (6 digits)
     if match = id.match(/^uva-lib:([0-9][0-9])?([0-9][0-9])?([0-9][0-9])?$/)
        d1, d2, d3 = match.captures
        key    = "uva-lib/#{d1}/#{d2}/#{d3}/#{d1}#{d2}#{d3}.jp2"
        bucket = iiif_bucket
        puts "INFO: rewrite [#{id}] -> [s3://#{bucket}/#{key}]"
        return { "bucket" => bucket, "key" => key }
     end

     # look for uva-lib:nnnnnnn (7 digits)
     if match = id.match(/^uva-lib:([0-9][0-9])?([0-9][0-9])?([0-9][0-9])?([0-9])?$/)
        d1, d2, d3, d4 = match.captures
        key    = "uva-lib/#{d1}/#{d2}/#{d3}/#{d4}/#{d1}#{d2}#{d3}#{d4}.jp2"
        bucket = iiif_bucket
        puts "INFO: rewrite [#{id}] -> [s3://#{bucket}/#{key}]"
        return { "bucket" => bucket, "key" => key }
     end

     # look for shanti-image-*nnn (3 digits)
     if match = id.match(/^shanti-image*-([0-9][0-9])?([0-9])?$/)
        d1, d2 = match.captures
        key    = "mandala-assets/#{d1}/#{d2}/shanti-image-#{d1}#{d2}.jp2"
        bucket = mandala_bucket
        puts "INFO: rewrite [#{id}] -> [s3://#{bucket}/#{key}]"
        return { "bucket" => bucket, "key" => key }
     end

     # look for shanti-image-*nnnn (4 digits)
     if match = id.match(/^shanti-image*-([0-9][0-9])?([0-9][0-9])?$/)
        d1, d2 = match.captures
        key    = "mandala-assets/#{d1}/#{d2}/shanti-image-#{d1}#{d2}.jp2"
        bucket = mandala_bucket
        puts "INFO: rewrite [#{id}] -> [s3://#{bucket}/#{key}]"
        return { "bucket" => bucket, "key" => key }
     end

     # look for shanti-image-*nnnnn (5 digits)
     if match = id.match(/^shanti-image*-([0-9][0-9])?([0-9][0-9])?([0-9])?$/)
        d1, d2, d3 = match.captures
        key    = "mandala-assets/#{d1}/#{d2}/#{d3}/shanti-image-#{d1}#{d2}#{d3}.jp2"
        bucket = mandala_bucket
        puts "INFO: rewrite [#{id}] -> [s3://#{bucket}/#{key}]"
        return { "bucket" => bucket, "key" => key }
     end

     # look for shanti-image-*nnnnnn (6 digits)
     if match = id.match(/^shanti-image*-([0-9][0-9])?([0-9][0-9])?([0-9][0-9])?$/)
        d1, d2, d3 = match.captures
        key    = "mandala-assets/#{d1}/#{d2}/#{d3}/shanti-image-#{d1}#{d2}#{d3}.jp2"
        bucket = mandala_bucket
        puts "INFO: rewrite [#{id}] -> [s3://#{bucket}/#{key}]"
        return { "bucket" => bucket, "key" => key }
     end

     # look for shanti-image-*nnnnnnn (7 digits)
     if match = id.match(/^shanti-image*-([0-9][0-9])?([0-9][0-9])?([0-9][0-9])?([0-9])?$/)
        d1, d2, d3, d4 = match.captures
        key    = "mandala-assets/#{d1}/#{d2}/#{d3}/#{d4}/shanti-image-#{d1}#{d2}#{d3}#{d4}.jp2"
        bucket = mandala_bucket
        puts "INFO: rewrite [#{id}] -> [s3://#{bucket}/#{key}]"
        return { "bucket" => bucket, "key" => key }
     end

     # look for shanti-image-*nnnnnnnn (8 digits)
     if match = id.match(/^shanti-image*-([0-9][0-9])?([0-9][0-9])?([0-9][0-9])?([0-9][0-9])?$/)
        d1, d2, d3, d4 = match.captures
        key    = "mandala-assets/#{d1}/#{d2}/#{d3}/#{d4}/shanti-image-#{d1}#{d2}#{d3}#{d4}.jp2"
        bucket = mandala_bucket
        puts "INFO: rewrite [#{id}] -> [s3://#{bucket}/#{key}]"
        return { "bucket" => bucket, "key" => key }
     end

     # look for dibs:xxxxxxxxx-nnn
     if match = id.match(/^dibs:([A-Z0-9]+)-?([0-9][0-9][0-9])?$/)
        d1, d2 = match.captures
        key    = "dibs/#{d1}/#{d1}-#{d2}.jp2"
        bucket = iiif_bucket
        puts "INFO: rewrite [#{id}] -> [s3://#{bucket}/#{key}]"
        return { "bucket" => bucket, "key" => key }
     end

     #
     # Less common
     #

     # look for tsm:nnnnnnn (7 digits)
     if match = id.match(/^tsm:([0-9][0-9])?([0-9][0-9])?([0-9][0-9])?([0-9])?$/)
        d1, d2, d3, d4 = match.captures
        key    = "tsm/#{d1}/#{d2}/#{d3}/#{d4}/#{d1}#{d2}#{d3}#{d4}.jp2"
        bucket = iiif_bucket
        puts "INFO: rewrite [#{id}] -> [s3://#{bucket}/#{key}]"
        return { "bucket" => bucket, "key" => key }
     end

     # look for jag:mlr:nnnnnn (6 digits)
     if match = id.match(/^jag:mlr:([0-9][0-9])?([0-9][0-9])?([0-9][0-9])?$/)
        d1, d2, d3 = match.captures
        key    = "law/jag/mlr/#{d1}/#{d2}/#{d3}/#{d1}#{d2}#{d3}.jp2"
        bucket = iiif_bucket
        puts "INFO: rewrite [#{id}] -> [s3://#{bucket}/#{key}]"
        return { "bucket" => bucket, "key" => key }
     end

     # look for law:archives:cnnnn (4 digits)
     if match = id.match(/^law:archives:c([0-9][0-9])?([0-9][0-9])?$/)
        d1, d2 = match.captures
        key    = "law/archives/#{d1}/#{d2}/#{d1}#{d2}.jp2"
        bucket = iiif_bucket
        puts "INFO: rewrite [#{id}] -> [s3://#{bucket}/#{key}]"
        return { "bucket" => bucket, "key" => key }
     end

     # look for law:archives:cnnnnn (5 digits)
     if match = id.match(/^law:archives:c([0-9][0-9])?([0-9][0-9])?([0-9])?$/)
        d1, d2, d3 = match.captures
        key    = "law/archives/#{d1}/#{d2}/#{d3}/#{d1}#{d2}#{d3}.jp2"
        bucket = iiif_bucket
        puts "INFO: rewrite [#{id}] -> [s3://#{bucket}/#{key}]"
        return { "bucket" => bucket, "key" => key }
     end

     # look for law:archives:cnnnnnn (6 digits)
     if match = id.match(/^law:archives:c([0-9][0-9])?([0-9][0-9])?([0-9][0-9])?$/)
        d1, d2, d3 = match.captures
        key    = "law/archives/#{d1}/#{d2}/#{d3}/#{d1}#{d2}#{d3}.jp2"
        bucket = iiif_bucket
        puts "INFO: rewrite [#{id}] -> [s3://#{bucket}/#{key}]"
        return { "bucket" => bucket, "key" => key }
     end

     # look for law:archives:cnnnnnnn (7 digits)
     if match = id.match(/^law:archives:c([0-9][0-9])?([0-9][0-9])?([0-9][0-9])?([0-9])?$/)
        d1, d2, d3, d4 = match.captures
        key    = "law/archives/#{d1}/#{d2}/#{d3}/#{d4}/#{d1}#{d2}#{d3}#{d4}.jp2"
        bucket = iiif_bucket
        puts "INFO: rewrite [#{id}] -> [s3://#{bucket}/#{key}]"
        return { "bucket" => bucket, "key" => key }
     end

     # look for law:pwct:nn (2 digits)
     if match = id.match(/^law:pwct:([0-9][0-9])?$/)
        d1 = match.captures[0]
        key    = "law/pwct/#{d1}/#{d1}.jp2"
        bucket = iiif_bucket
        puts "INFO: rewrite [#{id}] -> [s3://#{bucket}/#{key}]"
        return { "bucket" => bucket, "key" => key }
     end

     # look for law:pwct:nnn (3 digits)
     if match = id.match(/^law:pwct:([0-9][0-9])?([0-9])?$/)
        d1, d2 = match.captures
        key    = "law/pwct/#{d1}/#{d2}/#{d1}#{d2}.jp2"
        bucket = iiif_bucket
        puts "INFO: rewrite [#{id}] -> [s3://#{bucket}/#{key}]"
        return { "bucket" => bucket, "key" => key }
     end

     # look for law:pwct:nnnn (4 digits)
     if match = id.match(/^law:pwct:([0-9][0-9])?([0-9][0-9])?$/)
        d1, d2 = match.captures
        key    = "law/pwct/#{d1}/#{d2}/#{d1}#{d2}.jp2"
        bucket = iiif_bucket
        puts "INFO: rewrite [#{id}] -> [s3://#{bucket}/#{key}]"
        return { "bucket" => bucket, "key" => key }
     end

     # look for law:pwct:nnnnn (5 digits)
     if match = id.match(/^law:pwct:([0-9][0-9])?([0-9][0-9])?([0-9])?$/)
        d1, d2, d3 = match.captures
        key    = "law/pwct/#{d1}/#{d2}/#{d3}/#{d1}#{d2}#{d3}.jp2"
        bucket = iiif_bucket
        puts "INFO: rewrite [#{id}] -> [s3://#{bucket}/#{key}]"
        return { "bucket" => bucket, "key" => key }
     end

     # look for law:pwct:nnnnnn (6 digits)
     if match = id.match(/^law:pwct:([0-9][0-9])?([0-9][0-9])?([0-9][0-9])?$/)
        d1, d2, d3 = match.captures
        key    = "law/pwct/#{d1}/#{d2}/#{d3}/#{d1}#{d2}#{d3}.jp2"
        bucket = iiif_bucket
        puts "INFO: rewrite [#{id}] -> [s3://#{bucket}/#{key}]"
        return { "bucket" => bucket, "key" => key }
     end

     # look for law:mrcs:nn (2 digits)
     if match = id.match(/^law:mrcs:([0-9][0-9])?$/)
        d1 = match.captures[0]
        key    = "law/mrcs/#{d1}/#{d1}.jp2"
        bucket = iiif_bucket
        puts "INFO: rewrite [#{id}] -> [s3://#{bucket}/#{key}]"
        return { "bucket" => bucket, "key" => key }
     end

     # look for law:mrcs:nnn (3 digits)
     if match = id.match(/^law:mrcs:([0-9][0-9])?([0-9])?$/)
        d1, d2 = match.captures
        key    = "law/mrcs/#{d1}/#{d2}/#{d1}#{d2}.jp2"
        bucket = iiif_bucket
        puts "INFO: rewrite [#{id}] -> [s3://#{bucket}/#{key}]"
        return { "bucket" => bucket, "key" => key }
     end

     # look for law:mrcs:nnnn (4 digits)
     if match = id.match(/^law:mrcs:([0-9][0-9])?([0-9][0-9])?$/)
        d1, d2 = match.captures
        key    = "law/mrcs/#{d1}/#{d2}/#{d1}#{d2}.jp2"
        bucket = iiif_bucket
        puts "INFO: rewrite [#{id}] -> [s3://#{bucket}/#{key}]"
        return { "bucket" => bucket, "key" => key }
     end

     # look for law:mrcs:nnnnn (5 digits)
     if match = id.match(/^law:mrcs:([0-9][0-9])?([0-9][0-9])?([0-9])?$/)
        d1, d2, d3 = match.captures
        key    = "law/mrcs/#{d1}/#{d2}/#{d3}/#{d1}#{d2}#{d3}.jp2"
        bucket = iiif_bucket
        puts "INFO: rewrite [#{id}] -> [s3://#{bucket}/#{key}]"
        return { "bucket" => bucket, "key" => key }
     end

     # look for law:mrcs:nnnnnn (6 digits)
     if match = id.match(/^law:mrcs:([0-9][0-9])?([0-9][0-9])?([0-9][0-9])?$/)
        d1, d2, d3 = match.captures
        key    = "law/mrcs/#{d1}/#{d2}/#{d3}/#{d1}#{d2}#{d3}.jp2"
        bucket = iiif_bucket
        puts "INFO: rewrite [#{id}] -> [s3://#{bucket}/#{key}]"
        return { "bucket" => bucket, "key" => key }
     end

     # look for law:archives:rg32-400:name
     if match = id.match(/^law:archives:rg32-400:(.+)?$/)
        c1 = match.captures[0]
        key    = "law/archives/rg32-400/law:archives:rg32-400:#{c1}.jp2"
        bucket = iiif_bucket
        puts "INFO: rewrite [#{id}] -> [s3://#{bucket}/#{key}]"
        return { "bucket" => bucket, "key" => key }
     end

     # look for law:lile:nnn (3 digits)
     if match = id.match(/^law:lile:([0-9][0-9])?([0-9])?$/)
        d1, d2 = match.captures
        key    = "law/lile/#{d1}/#{d2}/#{d1}#{d2}.jp2"
        bucket = iiif_bucket
        puts "INFO: rewrite [#{id}] -> [s3://#{bucket}/#{key}]"
        return { "bucket" => bucket, "key" => key }
     end

     # look for static:n (1 digit)
     if match = id.match(/^static:([0-9])?$/)
        d1 = match.captures[ 0 ]
        key    = "static/#{d1}/#{d1}.jp2"
        bucket = iiif_bucket
        puts "INFO: rewrite [#{id}] -> [s3://#{bucket}/#{key}]"
        return { "bucket" => bucket, "key" => key }
     end

     # the failure case
     puts "ERROR: missing rewrite [#{id}]"
     { "bucket" => "none", "key" => "none" }
  end

  ##
  # Tells the server what overlay, if any, to apply to an image. Called upon
  # all image requests to any endpoint if overlays are enabled and the overlay
  # strategy is set to `ScriptStrategy` in the application configuration.
  #
  # Return values:
  #
  # 1. For string overlays, a hash with the following keys:
  #     * `background_color` [String] CSS-compliant RGA(A) color.
  #     * `color`            [String] CSS-compliant RGA(A) color.
  #     * `font`             [String] Font name. Launch with the -list-fonts
  #                          argument to see a list of available fonts.
  #     * `font_min_size`    [Integer] Minimum font size in points (ignored
  #                          when `word_wrap` is true).
  #     * `font_size`        [Integer] Font size in points.
  #     * `font_weight`      [Float] Font weight based on 1.
  #     * `glyph_spacing`    [Float] Glyph spacing based on 0.
  #     * `inset`            [Integer] Pixels of inset.
  #     * `position`         [String] Position like `top left`, `center right`,
  #                          etc.
  #     * `string`           [String] String to draw.
  #     * `stroke_color`     [String] CSS-compliant RGB(A) text outline color.
  #     * `stroke_width`     [Float] Text outline width in pixels.
  #     * `word_wrap`        [Boolean] Whether to wrap long lines within
  #                          `string`.
  # 2. For image overlays, a hash with the following keys:
  #     * `image`    [String] Image pathname or URL.
  #     * `position` [String] See above.
  #     * `inset`    [Integer] See above.
  # 3. nil for no overlay.
  #
  # @param options [Hash] Empty hash.
  # @return See above.
  #
  def overlay(options = {})
  end

  ##
  # Tells the server what regions of an image to redact in response to a
  # particular request. Will be called upon all image requests to any endpoint.
  #
  # @param options [Hash] Empty hash.
  # @return [Array<Hash<String,Integer>>] Array of hashes, each with `x`, `y`,
  #         `width`, and `height` keys; or an empty array if no redactions are
  #         to be applied.
  #
  def redactions(options = {})
    []
  end

  ##
  # Returns XMP metadata to embed in the derivative image.
  #
  # Source image metadata is available in the `metadata` context key, and has
  # the following structure:
  #
  # ```
  # {
  #     "exif": {
  #         "tagSet": "Baseline TIFF",
  #         "fields": {
  #             "Field1Name": value,
  #             "Field2Name": value,
  #             "EXIFIFD": {
  #                 "tagSet": "EXIF",
  #                 "fields": {
  #                     "Field1Name": value,
  #                     "Field2Name": value
  #                 }
  #             }
  #         }
  #     },
  #     "iptc": [
  #         "Field1Name": value,
  #         "Field2Name": value
  #     ],
  #     "xmp_string": "<rdf:RDF>...</rdf:RDF>",
  #     "xmp_model": https://jena.apache.org/documentation/javadoc/jena/org/apache/jena/rdf/model/Model.html
  #     "native": {
  #         # structure varies
  #     }
  # }
  # ```
  #
  # * The `exif` key refers to embedded EXIF data. This also includes IFD0
  #   metadata from source TIFFs, whether or not an EXIF IFD is present.
  # * The `iptc` key refers to embedded IPTC IIM data.
  # * The `xmp_string` key refers to raw embedded XMP data, which may or may
  #   not contain EXIF and/or IPTC information.
  # * The `xmp_model` key contains a Jena Model object pre-loaded with the
  #   contents of `xmp_string`.
  # * The `native` key refers to format-specific metadata.
  #
  # Any combination of the above keys may be present or missing depending on
  # what is available in a particular source image.
  #
  # Only XMP can be embedded in derivative images. See the user manual for
  # examples of working with the XMP model programmatically.
  #
  # @return [String,Model,nil] String or Jena model containing XMP data to
  #                            embed in the derivative image, or nil to not
  #                            embed anything.
  #
  def metadata(options = {})
  end

end
