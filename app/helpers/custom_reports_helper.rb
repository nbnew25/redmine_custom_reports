module CustomReportsHelper
  def sanitized_object_name(object_name)
    object_name.gsub(/\]\[|[^-a-zA-Z0-9:.]/, "_").sub(/_$/, "")
  end

  def query_options_for_select(query)
    options = query.sorted_available_filters.collect do |field|
      unless query.has_filter?(field[0])
        [field[1][:name] || l(("field_"+field[0].to_s.gsub(/_id$/, "")).to_sym), field[0]]
      end
    end
    options = [["", ""]] + options.compact
    options_for_select(options)
  end

  def link_to_add_custom_report_series(name, f)
    new_object = f.object.series.build
    id = new_object.object_id
    fields = f.fields_for(:series, new_object, child_index: id) do |builder|
      render("series", f: builder)
    end
    link_to(name, '#', :class => "add-custom-report-series",
            "data-id" => id, "data-fields" => fields.gsub("\n", ""))
  end

  def width_style_for_series(custom_report)
    if custom_report.multi_series?
      "width:100%;"
    else
      w = [800 / custom_report.series.count, 300].max
      "width:#{w}px;"
    end
  end
end