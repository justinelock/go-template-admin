package dal

import "gorm.io/gorm"

// AppDal App 品牌与版本表访问
type AppDal struct {
	db *gorm.DB
}

func NewAppDal(db *gorm.DB) *AppDal {
	return &AppDal{db: db}
}
