package metric

import (
	"errors"
	"fmt"
)

//Spec is specification of metric that generated by profiler or auditor
type Spec struct {
	Name    Type
	FieldID string
	TableID string

	//Condition is rule of invalidity, contains sql query and also an unique ID
	Condition string

	Owner Owner

	Metadata map[string]interface{}

	//Optional is the metric optional
	Optional bool
}

//SpecFinder for search specific metric specs from list of metric spec
type SpecFinder []*Spec

//GetMetricSpecsByFieldID to get metrics based on field Partition
func (msf SpecFinder) GetMetricSpecsByFieldID(fieldID string) ([]*Spec, error) {
	var specs []*Spec
	for _, spec := range []*Spec(msf) {
		if spec.FieldID == fieldID {
			specs = append(specs, spec)
		}
	}
	if len(specs) == 0 {
		errorMessage := fmt.Sprintf("metric spec with field id %s not found", fieldID)
		return nil, errors.New(errorMessage)
	}
	return specs, nil
}
