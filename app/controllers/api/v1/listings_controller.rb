# frozen_string_literal: true

module Api
  module V1
    class ListingsController < ApiController
      before_action :set_listing, only: %i[show update destroy]

      def index
        render_json paginate(ListingSerializer, Listing.all)
      end

      def show
        render_json ListingSerializer.new(@listing)
      end

      def create
        listing = Listing.new(listing_params)

        if listing.save
          render_json ListingSerializer.new(listing)
        else
          render_json_errors(listing: listing.errors.details)
        end
      end

      def update
        if @listing.update(listing_params)
          render_json ListingSerializer.new(@listing)
        else
          render_json_errors(listing: @listing.errors.details)
        end
      end

      def destroy
        if @listing.destroy
          render_json ListingSerializer.new(@listing)
        else
          render_json_errors(listing: @listing.errors.details)
        end
      end

      private

      def set_listing
        @listing = Listing.find(params[:id])
      end

      def listing_params
        params.require(:listing).permit(:num_rooms)
      end
    end
  end
end
